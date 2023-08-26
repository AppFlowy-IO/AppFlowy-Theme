/* eslint-disable */
import { onRequest } from 'firebase-functions/v2/https'
import { getUserDataByMail } from '../firestore/users';
import { db } from '../configs/firebase';
const { Stripe } = require('stripe');
const stripe = new Stripe(process.env.STRIPE_SECRET);

async function createAccount(email:string, accountType:string) {
  const accountsList = await stripe.accounts.list()
  const duplicatesList : Array<Object> = accountsList.data.filter((account:any) => account.email === email);
  if (duplicatesList.length > 0)
    console.log('has duplicate')  
  // throw new Error('Account with the same email already exists.');
  const customer = await stripe.accounts.create({ email: email, type: accountType });
  return customer;
}

const createAccountLink = onRequest(async (req, res) => {
  try {
    const accountLink = await stripe.accountLinks.create({
      account: req.body.stripeId,
      refresh_url: process.env.REDIRECT_URL,
      return_url: process.env.REDIRECT_URL,
      type: 'account_onboarding',
    });
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET');
    res.set('Access-Control-Allow-Headers', 'Content-Type');
    res.set('Access-Control-Max-Age', '3600');
    res.json(accountLink);
  } catch (err:any) {
    res.json(err);
  }
})

//TODO: check if error should be handled and whether it causes XMLhttprequest error
const createCheckoutSession = onRequest(async (req, res) => {
    const sellerDataQuery : any = await getUserDataByMail(req.body.uploaderEmail)
    // if(sellerDataQuery.docs.length === 0)
    //   throw new Error('no seller found with the given email')
    // else if(sellerDataQuery.docs.length > 0)
    //   throw new Error('found duplicate user with the given email')
    const cutPercentage = 10  //NOTE: the server decides how much the cut should be
    const sellerData = sellerDataQuery.docs[0].data()
    const cutAmount = cutPercentage/100 * parseInt(req.body.price, 10);
    const timeNow = new Date()
    const newCheckoutSession = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      mode: 'payment',
      invoice_creation: {
        enabled: true,
      },
      line_items: [
        {
          quantity: 1,
          price_data: {
            currency: 'usd',
            unit_amount: req.body.price * 100,
            product_data: {
              name: req.body.name,
              description: req.body.description ?? 'No description',
            }
          }
        }
      ],
      payment_intent_data: {
        application_fee_amount: cutAmount * 100,
        transfer_data: {
          destination: sellerData.stripeId
        },
      },
      metadata: {
        'productName': req.body.name,
        'productId': req.body.productId,
        'customerUid': req.body.customerUid ?? 'Guest checkout',
        'purchaseDate': timeNow.toLocaleDateString(),
      },
      allow_promotion_codes: true,
      'success_url': process.env.REDIRECT_URL,
      'cancel_url': process.env.REDIRECT_URL,
    })
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET');
    res.set('Access-Control-Allow-Headers', 'Content-Type');
    res.set('Access-Control-Max-Age', '3600');
    res.json(newCheckoutSession)
})

const stripeWebhook = onRequest(async (req, res) => {
  try {
    const event = stripe.webhooks.constructEvent(
      req.rawBody,
      req.headers['stripe-signature'],
      process.env.WEBHOOK_SECRET
    )
    const metadata = event.data.object.metadata;
    const result = await db.collection(`Users/${metadata.customerUid}/Orders`).doc(metadata.productId).set(event.data.object)
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET');
    res.set('Access-Control-Allow-Headers', 'Content-Type');
    res.set('Access-Control-Max-Age', '3600');
    res.status(200).send(result);
  } catch (err:any) {
    res.status(400).send(`Webhook Error: ${err.message}`)
  }
})

export {
  createAccount,
  createAccountLink,
  createCheckoutSession,
  stripeWebhook,
}
import { Stripe } from "https://esm.sh/stripe@13.2.0?target=deno&no-check";

const redirectUrl = Deno.env.get('_REDIRECT_URL') as string;
const stripeKey = Deno.env.get('_STRIPE_SECRET') as string;

const stripe: any = Stripe(stripeKey, {
  httpClient: Stripe.createFetchHttpClient(),
});

if(stripe == null || stripe == undefined)
 throw Error('Error constructing Stripe object');

const cryptoProvider = Stripe.createSubtleCryptoProvider();

const createAccount = async (email:string, accountType:string) => {
  const accountsList = await stripe.accounts.list()
  const duplicatesList = accountsList.data.filter((account:any) => account.email === email);
  if (duplicatesList.length > 0)
    console.log('has duplicate')  
  // throw new Error('Account with the same email already exists.');
  const customer = await stripe.accounts.create({ email: email, type: accountType });
  return customer;
}

const createAccountLink = async (stripeId:string) => {
  const accountLink = await stripe.accountLinks.create({
    account: stripeId,
    refresh_url: redirectUrl,
    return_url: redirectUrl,
    type: 'account_onboarding',
  });
  return accountLink;
}

const createCheckoutSession = async (reqData:any, sellerData:any) => {
  const cutPercentage = 10  //NOTE: the server decides how much the cut should be
  const cutAmount = cutPercentage/100 * parseInt(reqData.price, 10);
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
          unit_amount: reqData.price * 100,
          product_data: {
            name: reqData.name,
            description: reqData.description ?? 'No description',
          }
        }
      }
    ],
    payment_intent_data: {
      application_fee_amount: cutAmount * 100,
      transfer_data: {
        destination: sellerData.stripe_id
      },
    },
    metadata: {
      'productName': reqData.name,
      'productId': reqData.productId,
      'customerUid': reqData.customerUid ?? 'Guest checkout',
      'purchaseDate': timeNow.toLocaleDateString(),
    },
    allow_promotion_codes: true,
    'success_url': redirectUrl,
    'cancel_url': redirectUrl,
  })
  return newCheckoutSession;
}

export {
  stripe,
  createAccount,
  createAccountLink,
  createCheckoutSession,
  cryptoProvider,
}
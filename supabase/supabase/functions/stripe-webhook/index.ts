import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { newOrder } from '../_utils/db.ts'
import { stripe, cryptoProvider } from '../_utils/stripe.ts'

serve(async (req) => {
  const webhook_secret = Deno.env.get('_STRIPE_WEBHOOK_SECRET') as string
  const signature = req.headers.get('Stripe-Signature')
  const headers = {
    'Access-Control-Allow-Origin': '*', //TODO: IMPORTANT replace the allowed origin in production
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '3600',
  }

  if (req.method === 'OPTIONS') return new Response(null, { headers })

  const parameters = req.clone()
  const { data } = await parameters.json()
  const body = await req.text()

  let event
  try {
    event = await stripe.webhooks.constructEventAsync(body, signature, webhook_secret, undefined, cryptoProvider);
  } catch (e) {
    return new Response(JSON.stringify(e), { status: 400 })
  }
  
  await newOrder(data.object)
  return new Response(
    JSON.stringify("OK"),
    { headers: { "Content-Type": "application/json" } },
  )
})
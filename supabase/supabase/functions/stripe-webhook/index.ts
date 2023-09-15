import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { newOrder } from '../_utils/db.ts'
import { stripe, cryptoProvider } from '../_utils/stripe.ts'
import { corsHeaders } from '../_utils/cors.ts'

serve(async (req) => {
  const webhook_secret = Deno.env.get('_STRIPE_WEBHOOK_SECRET') as string
  const signature = req.headers.get('Stripe-Signature')

  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const parameters = req.clone()
  const { data } = await parameters.json()
  const body = await req.text()

  try {
    await stripe.webhooks.constructEventAsync(body, signature, webhook_secret, undefined, cryptoProvider);
  } catch (e) {
    return new Response(JSON.stringify(e), { status: 400, headers: corsHeaders })
  }  
  await newOrder(data.object)
  return new Response(
    JSON.stringify("OK"),
    { headers: { "Content-Type": "application/json" } },
  )
})
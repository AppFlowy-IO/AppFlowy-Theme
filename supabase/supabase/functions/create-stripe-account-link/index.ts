import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createAccountLink } from '../_utils/stripe.ts'

console.log("Hello from Functions!")

serve(async (req) => {
  const headers = {
    'Access-Control-Allow-Origin': '*', //TODO: IMPORTANT replace the allowed origin in production
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '3600',
  };
  const data = await req.json()
  try {
    const res = await createAccountLink(data.stripeId);
    return new Response(JSON.stringify(res), { headers: { 'Content-Type': 'application/json' } })
  } catch (e) {
    console.log(e);
    return new Response(JSON.stringify(e), { status: 400 });
  }
  return new Response(
    JSON.stringify(data),
    { headers: { "Content-Type": "application/json" } },
  )
})
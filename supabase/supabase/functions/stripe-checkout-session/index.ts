import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createCheckoutSession } from '../_utils/stripe.ts'
import { findUserByMail } from '../_utils/db.ts'

serve(async (req) => {
  const headers = {
    'Access-Control-Allow-Origin': '*', //TODO(a-wallen): IMPORTANT update  the allowed origin in production
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Max-Age': '86400', // 24 hours
  };
  
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers });
  } 

  try {
    const reqData = await req.json()
    const sellerData = await findUserByMail(reqData.uploaderEmail)
    const newCheckoutSession = await createCheckoutSession(reqData, sellerData);
    return new Response(JSON .stringify(newCheckoutSession), { headers: headers })
  } catch (e) {
    console.log(e)
    return new Response(JSON.stringify(e), { status: 400 });
  }
})
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createAccount } from '../_utils/stripe.ts'
import { updateUserByMail } from '../_utils/db.ts'

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    const headers = {
      'Access-Control-Allow-Origin': '*', //TODO: IMPORTANT replace the allowed origin in production
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Max-Age': '86400', // 24 hours
    };
    return new Response(null, { headers });
  } 
 
  try {
    const headers = {
      'Access-Control-Allow-Origin': '*', //TODO: IMPORTANT replace the allowed origin in production
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Max-Age': '3600',
    };
    const data = await req.json();
    const res = await createAccount(data.email, 'standard');
    await updateUserByMail(data.email, res.id)
    return new Response(JSON.stringify(res), { headers: { 'Content-Type': 'application/json' } })
  } catch (e) {
    console.log(e);
    return new Response(JSON.stringify(e), { status: 400 });
  }
})

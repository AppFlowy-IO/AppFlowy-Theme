import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createCheckoutSession } from '../_utils/stripe.ts'
import { findUserByMail } from '../_utils/db.ts'
import { corsHeaders } from "../_utils/cors.ts";

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  } 

  try {
    const reqData = await req.json()
    const sellerData = await findUserByMail(reqData.uploaderEmail)
    const newCheckoutSession = await createCheckoutSession(reqData, sellerData);
    return new Response(JSON .stringify(newCheckoutSession), { status: 200, headers: corsHeaders })
  } catch (e) {
    console.log(e)
    return new Response(JSON.stringify(e), { status: 400, headers: corsHeaders });
  }
})
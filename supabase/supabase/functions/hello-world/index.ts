import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { createCheckoutSession } from '../_utils/stripe.ts'
import { findUserByMail } from '../_utils/db.ts'

const supUrl = Deno.env.get('_SUPABASE_URL') as string;
const supKey = Deno.env.get('_SUPABASE_SERVICE_KEY') as string;
const supabase = createClient(supUrl, supKey);

serve(async (req) => {
  const headers = {
    'Access-Control-Allow-Origin': '*', //TODO: IMPORTANT replace the allowed origin in production
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '3600',
  };

  try {
    const reqData = await req.json()
    const sellerData = await findUserByMail(reqData.uploaderEmail)
    const cutPercentage = 10  //NOTE: the server decides how much the cut should be
    const cutAmount = cutPercentage/100 * parseInt(reqData.price, 10);
    const timeNow = new Date()
    const newCheckoutSession = await createCheckoutSession(reqData, sellerData);
    return new Response(JSON .stringify(newCheckoutSession), { headers: headers })
  } catch (e) {
    console.log(e)
    return new Response(JSON.stringify(e), { status: 400 });
  }
})
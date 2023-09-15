import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createAccountLink } from '../_utils/stripe.ts'
import { corsHeaders } from "../_utils/cors.ts";

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  } 
  
  try {
    const data = await req.json()
    console.log(data)
    const res = await createAccountLink(data.stripeId);
    return new Response(JSON.stringify(res), { status: 200, headers: corsHeaders })
  } catch (e) {
    console.error(e);
    return new Response(JSON.stringify(e), { status: 400, headers: corsHeaders });
  }
})
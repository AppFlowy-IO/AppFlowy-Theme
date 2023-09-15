import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createAccount } from '../_utils/stripe.ts'
import { updateUserByMail } from '../_utils/db.ts'
import { corsHeaders } from '../_utils/cors.ts';

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { status: 200, headers: corsHeaders });
  } 
 
  //TODO(a-wallen): test duplicate stripe account registration
  try {
    const data = await req.json();
    const res = await createAccount(data.email, 'standard');
    await updateUserByMail(data.email, res.id)
    return new Response(JSON.stringify(res), { status: 200, headers: corsHeaders })
  } catch (e) {
    console.error(e);
    return new Response(JSON.stringify(e), { status: 400, headers: corsHeaders });
  }
})

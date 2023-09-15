import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { corsHeaders } from '../_utils/cors.ts'
import { getAccountInfo } from '../_utils/stripe.ts'
import { findUserByStripeId } from "../_utils/db.ts";

serve(async (req:Request) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const apiKey = req.headers.get('apikey');
    const authorizationHeader = req.headers.get('Authorization');
    if(apiKey === null || apiKey === undefined)
      return new Response(JSON.stringify({ message: 'Missing api key' }), { status: 400, headers: corsHeaders })
    if(authorizationHeader === null || authorizationHeader === undefined)
      return new Response(JSON.stringify({ message: 'Missing credential to perform action' }), { status: 400, headers: corsHeaders })  

    const taskPattern = new URLPattern({ pathname: '/get-account-info/:id' })
    const matchingPath = taskPattern.exec(req.url)
    const stripeId = matchingPath ? matchingPath.pathname.groups.id : null
    if(stripeId === null || stripeId == undefined)
      return new Response(JSON.stringify({ message: 'Missing stripe id' }), { status: 400, headers: corsHeaders })
    
    const token = authorizationHeader.replace('Bearer ', '');
    const decodedToken = JSON.parse(atob(token.split('.')[1])); // Decode and parse JWT payload
    const { uid } = await findUserByStripeId(stripeId!);
    if(uid !== decodedToken.sub) 
      return new Response(JSON.stringify({ message: 'Not authorized to perform action' }), { status: 400, headers: corsHeaders })
    
    if(stripeId && req.method === 'GET') {
      console.log(stripeId);
      const accountData = await getAccountInfo(stripeId);
      console.log('acctData: ' + accountData)
      return new Response(
        JSON.stringify(accountData),
        { headers: corsHeaders, status: 200 },
      )
    }
    return new Response(JSON.stringify('Bad Request'), { status: 400 , headers: corsHeaders })
  } catch (e) {
    console.error(e)
    return new Response(JSON.stringify('Not authorized to perform action'), { status: 400 , headers: corsHeaders })
  }
})
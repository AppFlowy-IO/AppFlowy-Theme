import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { findPurchasedOrder, getSignedUrl, findUploader } from '../_utils/db.ts'
import { corsHeaders } from "../_utils/cors.ts";

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  } 
  
  try {
    const { customer_id, plugin_id } = await req.json()
    const apiKey = req.headers.get('apikey');
    const authorizationHeader = req.headers.get('Authorization');
    if(apiKey === null || apiKey === undefined)
      return new Response(JSON.stringify({ message: 'Missing api key' }), { status: 400 })
    if(authorizationHeader === null || authorizationHeader === undefined)
      return new Response(JSON.stringify({ message: 'Missing credential to perform action' }), { status: 400, headers: corsHeaders })  
    
    const token = authorizationHeader.replace('Bearer ', '');
    const decodedToken = JSON.parse(atob(token.split('.')[1])); // Decode and parse JWT payload
    if(customer_id !== decodedToken.sub) 
      return new Response(JSON.stringify({ message: 'Not authorized to perform action' }), { status: 400, headers: corsHeaders })
    const { uploader_id, name } = await findUploader(plugin_id)
    
    let downloadUrl
    if(customer_id === uploader_id) {
      console.log('is uploader')
      downloadUrl = await getSignedUrl(uploader_id, name)      
    }

    else {
      console.log('is buyer')
      const findOrder = await findPurchasedOrder(customer_id, plugin_id)
      if(findOrder === null || findOrder === undefined)
        return new Response(JSON.stringify({message: 'Cannot find order with given data'}), { status: 400, headers: corsHeaders })
      const { product_name } = findOrder
      downloadUrl = await getSignedUrl(uploader_id, product_name)      
    }

    return new Response(JSON.stringify({ signedUrl: downloadUrl }), {
      headers: corsHeaders,
      status: 200,
    })
  } catch (e) {
    console.error(e)
    return new Response(JSON.stringify({ message: 'Not authorized to perform action' }), { status: 400, headers: corsHeaders })
  }
})

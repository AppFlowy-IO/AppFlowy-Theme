import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.33.1'

const supUrl = Deno.env.get('_SUPABASE_URL') as string;
const supKey = Deno.env.get('_SUPABASE_SERVICE_KEY') as string;
const supabase = createClient(supUrl, supKey);

const duplicateCheck = (data: any[] | null) => {
  if(data == null)
    return null
  if(data.length == 0)
    return null
  if(data.length > 1)
    throw Error('Duplicate user with the same email');
  return data[0];
}

const findUserByMail = async (email:string) => {
  const { data } = await supabase.from('users').select('*').eq('email', email)
  return duplicateCheck(data);
}

const findUserByStripeId = async (stripeId:string) => {
  const { data } = await supabase.from('users').select('*').eq('stripe_id', stripeId)
  return duplicateCheck(data);
}

const updateUserByMail = async (email:string, stripeId:string) => {
  await supabase
    .from('users')
    .update({ stripe_id: stripeId })
    .eq('email', email)
}

const newOrder = async(reqData:any) => {
  const { data } = await supabase.from('users').select('email').eq('uid', reqData.metadata.customerUid)
  const customer = duplicateCheck(data)
  const res = await supabase.from('orders').insert({
    'customer_id': reqData.metadata.customerUid,
    'plugin_id': reqData.metadata.productId,
    'order_detail': reqData,
    'product_name': reqData.metadata.productName,
    'customer_email': customer.email,
  });
  return res;
}

const findPurchasedOrder = async(customerUid: string, pluginId: string) => {
  const { data } = await supabase
  .from('orders')
  .select('customer_id, plugin_id, product_name, customer_email')
  .eq('customer_id', customerUid)
  .eq('plugin_id', pluginId)
  const res = duplicateCheck(data)
  return res;
}

const findUploader = async(pluginId: string) => {
  const { data } = await supabase
    .from('files')
    .select('uploader_name, uploader_id, uploader_email, name')
    .eq('plugin_id', pluginId)
  const res = duplicateCheck(data)
  return res;
}

const getSignedUrl = async (sellerUid: string, pluginName: string) => {
  const path = `${sellerUid}/${pluginName}`
  const bucket = 'paid_plugins'
  const { data, error } = await supabase.storage.from(bucket).createSignedUrl(path, 60)
  if(error != null || error != undefined)
    console.error(`error: ${error}`);
  const downloadUrl: string | undefined = data?.signedUrl
  return downloadUrl
}

export {
  findUserByMail,
  findUserByStripeId,
  updateUserByMail,
  newOrder,
  findPurchasedOrder,
  findUploader,
  getSignedUrl,
}
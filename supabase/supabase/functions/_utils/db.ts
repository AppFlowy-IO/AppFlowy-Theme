import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.33.1'

const supUrl = Deno.env.get('_SUPABASE_URL') as string;
const supKey = Deno.env.get('_SUPABASE_SERVICE_KEY') as string;
const supabase = createClient(supUrl, supKey);

const duplicateCheck = (data: any[] | null) : any[] => {
  if(data == null)
    throw Error('data is null');
  if(data.length == 0)
    throw Error('User does not exist')
  if(data.length > 1)
    throw Error('Duplicate user with the same email');
  return data;
}

const findUserByMail = async (email:string) => {
  const sellerData = await supabase.from('users').select('*').eq('email', email)
  const data = sellerData.data
  return duplicateCheck(data)[0];
}

const updateUserByMail = async (email:string, stripeId:string) => {
  await supabase
    .from('users')
    .update({ stripe_id: stripeId })
    .eq('email', email)
}

const newOrder = async(reqData:any) => {
  console.log(reqData)
  const customer_data = await supabase.from('users').select('email').eq('uid', reqData.metadata.customerUid)
  let customers = customer_data.data
  customers = duplicateCheck(customers)

  const res = await supabase.from('orders').insert({
    'customer_id': reqData.metadata.customerUid,
    'plugin_id': reqData.metadata.productId,
    'order_detail': reqData,
    'product_name': reqData.metadata.productName,
    'customer_email': customers[0].email,
  });
  return res;
}

// const newOrder = async(reqData) => {
//   const customer_data = await supabase.from('users').select('email').eq('uid', reqData.metadata.customerUid)
//   const res = await supabase.from('orders').insert({
//     'customer_id': reqData.metadata.customerUid,
//     'plugin_id': reqData.metadata.productId,
//     'order_detail': reqData,
//     'product_name': reqData.metadata.productName,
//     'customer_email': customer_data.data[0].email,
//   });
//   return res;
// }

export {
  findUserByMail,
  updateUserByMail,
  newOrder,
}
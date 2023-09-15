export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, Origin, X-Requested-With, Accept',
  'Content-Type': 'application/json',
  'Access-Control-Max-Age': '86400', // 24 hours
}

export const headers = {
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
};
class SupabaseApi {
  static const supabaseUrl = 'https://zrcomcrmmuwrclfwvknj.supabase.co';
  static const functionUrl = '$supabaseUrl/functions/v1';
  static const createStripeAccount = '$functionUrl/create-stripe-account';
  static const createStripeAccountLink = '$functionUrl/create-stripe-account-link';
  static const stripeCheckoutSession = '$functionUrl/stripe-checkout-session';
}
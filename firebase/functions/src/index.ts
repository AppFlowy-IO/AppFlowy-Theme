import { updateUsername, onUserRegistered } from './firestore/users'
// import { onFileUploadComplete } from './storage/storage'
import { testHelpers } from './utils/utils'
import { createAccountLink, createCheckoutSession, stripeWebhook } from './payment/stripe'
import cors from 'cors';

cors({
  origin: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
});

export {
  updateUsername,
  onUserRegistered,
  // onFileUploadComplete,
  testHelpers,
  createAccountLink,
  createCheckoutSession,
  stripeWebhook,
}

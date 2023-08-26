import { onRequest } from 'firebase-functions/v2/https';
import { admin } from '../configs/firebase'
import { getUserDataByMail } from '../firestore/users';

async function validateUser(token: string, requestUid: string, requestEmail: string) {
  const decodedToken = await getDecodedToken(token);
  return decodedToken.uid == requestUid && decodedToken.email == requestEmail
}

async function getDecodedToken(token: string) {
  const decodedToken = await admin.auth().verifyIdToken(token)
  return decodedToken;
}

function userFacingMessage(err:any) {
  console.log(`dev environment: ${process.env.ENVIRONMENT}`)
  if(process.env.ENVIRONMENT === 'development')
    console.log(err)
  return err.type ? err.message : 'An error occurred, developers have been alerted'
}

const testHelpers = onRequest(async (req, res) => {
  // await createAccount(req.body.email, 'standard')
  await getUserDataByMail(req.body.uploaderEmail)
  res.json();
})

export { validateUser, getDecodedToken, userFacingMessage, testHelpers }

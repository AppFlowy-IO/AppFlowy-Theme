/* eslint-disable */
import * as functions from 'firebase-functions'
import { db } from '../configs/firebase'
import { onRequest } from 'firebase-functions/v2/https'
import { DocumentSnapshot } from 'firebase-admin/firestore'
import { UploaderData } from '../models/uploader'
import { userFacingMessage, validateUser } from '../utils/utils'
import { createAccount } from '../payment/stripe'

const updateUsername = onRequest(async (req, res) => {
  try {
    const authToken : string = req.headers.authorization || ''
    const validateSuccess = await validateUser(authToken.split(' ')[1], req.body.uid, req.body.email)
    if(validateSuccess){
      await db.collection('Users').doc(req.body.uid).update({ name: req.body.name })
      res.status(200).json({message: 'user data updated'})
    }
    else
      res.status(401).json({ error: 'User not authorized' })
  } catch (err) {
    res.status(500).json({ error: err })
  }
})

async function getUserDataByMail(email: string) {
  const userData = await db.collection('Users').where('email', '==', email).get()
  return userData
}

const getUserData = onRequest(async (req, res) => {
  try {
    const authToken : string = req.headers.authorization || ''
    const validateSuccess = await validateUser(authToken.split(' ')[1], req.body.uid, req.body.email)
    if(validateSuccess){
      const userData : DocumentSnapshot = await db.collection('Users').doc(req.body.uid).get()
      res.status(200).json(userData)
    }
    else
      res.status(401).json({ error: 'Unauthorized. Please login to access this resource.' })
  } catch (err) {
    res.status(500).json({ error: err })
  }
})

const updatePurchasedItems = onRequest(async (req, res) => {
  try {
    const authToken : string = req.headers.authorization || ''
    const validateSuccess = await validateUser(authToken.split(' ')[1], req.body.uid, req.body.email)
    if(validateSuccess){
      await db.collection('Users').doc(req.body.uid).update({ purchasedItems: req.body.purchasedItems })
      res.status(200).json({message: 'user data updated'})
    }
    else
      throw new Error('user not authorized')
  } catch (e) {
    res.status(401).json({ error: 'Unauthorized. Please login to access this resource.' })
  }
})

const onUserRegistered = functions.auth.user().onCreate(async (user) => {
  if(user == null)
    throw Error('There is no user')
  try{
    if(user.email == null)
      throw new Error('user\' email is missing')
    const stripeInfo = await createAccount(user.email!, 'standard')
    const userData : UploaderData = {
      uid: user.uid,
      name: user.displayName || 'Anonymous User',
      email: user.email,
      stripeId: stripeInfo.id,
      purchasedItems: [],
    }
    await db.collection('Users').doc(user.uid).create(userData)
  } catch(err) {
    userFacingMessage(err)
  }
})

// async function deleteUser(userId:string) {

// }

// async function fallBackRegistration() {

// }

export {
  updateUsername,
  onUserRegistered,
  updatePurchasedItems,
  getUserData,
  getUserDataByMail,
}

import { onRequest } from 'firebase-functions/v2/https'
import { db } from '../configs/firebase'
import { PluginZipFile } from '../models/plugin_zip_file'
import { getDecodedToken } from '../utils/utils'
import { storage } from '../configs/firebase'
import { Timestamp } from 'firebase-admin/firestore'
import functions = require('firebase-functions');
import { ObjectMetadata } from 'firebase-functions/v1/storage'

// import { Bucket } from '@google-cloud/storage'
// import {Filter} from 'bad-words'

function validateUploadFile(bytes : Uint8Array) : boolean {
  return false;
}

// const getPersistentDownloadUrl = (bucket:Bucket, pathToFile:string, downloadToken:string) => {
//   console.log(bucket)
//   console.log(pathToFile)
//   console.log(downloadToken)
//   return `https://firebasestorage.googleapis.com/v0/b/${bucket}/o/${encodeURIComponent(
//     pathToFile
//   )}?alt=media&token=${downloadToken}`;
// };

const uploadFile = onRequest(async (req, res) => {
  const authToken : string = req.headers.authorization || ''
  const bytesFile: Buffer = Buffer.from(req.body.bytesFile)
  const fileName : string = req.body.fileName
  const uploaderName : string = req.body.uploaderName
  const price : number = req.body.price
  try {
    const decodedToken = await getDecodedToken(authToken.split(' ')[1]);
    if(validateUploadFile(bytesFile))
      res.status(401).json({ error: 'Validation failed! Cannot upload file with profanity' })
    const folder = price === 0 ? 'public' : 'private'
    const path = `${folder}/${decodedToken.uid}/${fileName}`
    const file = storage.file(path)
    const metadata = {
      contentType: 'application/zip',
      customMetadata: {
        uploaderName: uploaderName ?? 'Anonymous user',
        uploaderEmail: decodedToken.email ?? 'Unknown',
      },
    }

    try{
      const zipFile : PluginZipFile = {
        downloadCount: 0,
        name: fileName || 'undefined',
        rating: 0,
        ratingCount: 0,
        uploadDate: Timestamp.now(),
        downloadURL: '',
        price: price || -1,
        uploader: {
          name: uploaderName,
          email: decodedToken.email,
        },
      }
      await file.save(bytesFile, {metadata});
      // const [signedUrl] = await file.getSignedUrl({action: 'read', expires: '01-01-2030' });
      // console.log(`signed Url: ${signedUrl}`)
      // const currentTimestamp = admin.firestore.Timestamp.now();
      // const expirationTime = new admin.firestore.Timestamp(currentTimestamp.seconds + 60, 0); // expire after 1 minute
      // const downloadUrl : string = getPersistentDownloadUrl(storage, path, signedUrl)
      // console.log(`persistentUrl: ${downloadUrl}`)
      await db.collection(`Files/`).doc().create(zipFile);
    } catch(err:any) {
      console.log(err)
      res.status(401).json({error: err.code})
    }
    res.status(200).json({message: 'upload success'})
  } catch(err:any){
    if (err.code === 'auth/invalid-id-token')
      res.status(401).json({ error: 'Invalid token' })
    else if (err.code === 'auth/argument-error')
      res.status(401).json({ error: 'User not authorized' })
    else
      res.status(401).json({ error: err.code })
  }
})

const onFileUploadComplete = functions.storage.object().onFinalize(async (fileObj: ObjectMetadata) => {
  try {
    const fileName:string = fileObj.name && fileObj.name.split('/')[2] || 'untitled'
    const zipFile: PluginZipFile = {
      downloadCount: 0,
      name: fileName,
      rating: 0,
      ratingCount: 0,
      uploadDate: Timestamp.now(),
      downloadURL: '',
      price: parseFloat(fileObj.metadata?.price || '0'),
      uploader: {
        name: fileObj.metadata?.uploaderName || 'Anonymouse User',
        email: fileObj.metadata?.uploaderEmail || 'Unknown uploader',
      },
    }
    // TODO: move to /firestore, client calls this route instead of directly on the firebase
    // check for duplicate, then decide whether to add or to update
    //  const list = await db.collection(`Files/`).doc().where('name', '==', fileObj.name).get()
    await db.collection(`Files/`).doc().create(zipFile)
  } catch (err: any) {
    throw new Error(`something wrong updating the database error: ${err}`)
  }
})

export { uploadFile, onFileUploadComplete }

import admin from 'firebase-admin';
// const serviceAccount = require("../../service_account.json");
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// })
admin.initializeApp();

const db = admin.firestore();
db.settings({ ignoreUndefinedProperties: true })

const storage = admin.storage().bucket();

export {admin, db, storage};

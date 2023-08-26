/* eslint-disable */

import { Timestamp } from 'firebase-admin/firestore'

type PluginZipFile = {
  downloadCount: number
  name: string
  rating: number
  ratingCount: number
  uploadDate: Timestamp
  downloadURL: string
  price: number
  uploader: {}
}

export { PluginZipFile }

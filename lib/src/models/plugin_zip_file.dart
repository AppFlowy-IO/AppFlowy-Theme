import 'package:cloud_firestore/cloud_firestore.dart';

class PluginZipFile {
  final int downloadCount;
  final String name;
  final double rating;
  final int ratingCount;
  final Timestamp uploadDate;
  final String downloadURL;
  final double price;
  final Map<String, dynamic> uploader;

  PluginZipFile({
    required this.downloadCount,
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.uploadDate,
    required this.downloadURL,
    required this.price,
    required this.uploader,
  });

  PluginZipFile.fromJson(Map<String, dynamic> object)
  : downloadCount = object['download_count'],
    name = object['name'],
    rating = object['rating'],
    ratingCount = object['ratingCount'],
    uploadDate = object['uploaded_on'],
    downloadURL = object['downloadURL'],
    price = object['price'],
    uploader = object['uploader'];

  Map<String, dynamic> toJson() => {
    'download_count': downloadCount,
    'name': name,
    'rating': rating,
    'ratingCount': ratingCount,
    'uploaded_on': uploadDate,
    'downloadURL': downloadURL,
    'price': price,
    'uploader': uploader,
  };
}
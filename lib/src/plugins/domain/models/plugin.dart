import 'package:appflowy_theme_marketplace/src/plugins/domain/models/picked_file.dart';
import 'package:uuid/uuid.dart';

import 'user.dart';

class Plugin {
  final String pluginId;
  final int downloadCount;
  final String downloadURL;
  final String name;
  final double rating;
  final int ratingCount;
  final DateTime? uploadDate;
  final PickedFile? pickedFile;
  final double price;
  final User uploader;

  Plugin({
    required this.pluginId,
    required this.downloadCount,
    String? downloadURL,
    required this.name,
    required this.rating,
    required this.ratingCount,
    this.uploadDate,
    this.pickedFile,
    required this.price,
    required this.uploader,
  }) : downloadURL = downloadURL ?? '';

  factory Plugin.upload({
    PickedFile? pickedFile,
    required String name,
    required User uploader,
    DateTime? uploadDate,
    String? downloadURL,
    required double price,
  }) =>
      Plugin(
        pluginId: const Uuid().v4(),
        downloadCount: 0,
        downloadURL: downloadURL ?? '',
        name: name,
        rating: 0,
        ratingCount: 0,
        pickedFile: pickedFile,
        price: price,
        uploader: uploader,
      );

  Plugin.fromJson(Map<String, dynamic> object)
      : pluginId = object['plugin_id'],
        downloadCount = object['download_count'],
        downloadURL = object['download_url'],
        name = object['name'],
        rating = object['rating'],
        ratingCount = object['rating_count'],
        uploadDate = DateTime.parse(object['created_at']),
        pickedFile = null,  // pickedFile is always null when receive data from a json request
        price = object['price'],
        uploader = User(
          uid: object['uploader_id'],
          name: object['uploader_name'],
          email: object['uploader_email'],
        );

  Map<String, dynamic> toJson() => {
    'plugin_id': pluginId,
    'download_count': downloadCount,
    'download_url': downloadURL,
    'name': name,
    'rating': rating,
    'rating_count': ratingCount,
    if (uploadDate != null) 'created_at': uploadDate.toString(),
    'price': price,
    'uploader_id': uploader.uid,
    'uploader_email': uploader.email,
    'uploader_name': uploader.name,
  };
}

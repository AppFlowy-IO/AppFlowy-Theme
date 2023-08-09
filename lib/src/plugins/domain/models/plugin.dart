import 'package:appflowy_theme_marketplace/src/plugins/domain/models/pickedFile.dart';
import 'package:uuid/uuid.dart';

import 'user.dart';

class Plugin {
  final String pluginId;
  final int downloadCount;
  final String downloadURL;
  final String name;
  final double rating;
  final int ratingCount;
  final DateTime uploadDate;
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
    required this.uploadDate,
    required this.pickedFile,
    required this.price,
    required this.uploader,
  }) : downloadURL = downloadURL ?? '';

  factory Plugin.upload({
    PickedFile? pickedFile,
    required String name,
    required User uploader,
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
        uploadDate: DateTime.now(),
        pickedFile: pickedFile,
        price: price,
        uploader: uploader,
      );

  Plugin.fromJson(Map<String, dynamic> object)
      : pluginId = object['plugin_id'],
        downloadCount = object['download_count'],
        downloadURL = object['downloadURL'],
        name = object['name'],
        rating = object['rating'],
        ratingCount = object['ratingCount'],
        uploadDate = object['uploaded_on'],
        pickedFile = null,  // pickedFile is always null when receive data from a json request
        price = object['price'],
        uploader = User(
          uid: object['uploader']['uid'],
          name: object['uploader']['name'],
          email: object['uploader']['email'],
        );

  Map<String, dynamic> toJson() => {
        'plugin_id': pluginId,
        'download_count': downloadCount,
        'downloadURL': downloadURL,
        'name': name,
        'rating': rating,
        'ratingCount': ratingCount,
        'uploaded_on': uploadDate,
        'price': price,
        'uploader': {
          'email': uploader.email,
          'name': uploader.name,
          'uid': uploader.uid,
        },
      };
}

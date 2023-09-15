import 'dart:collection';
import 'dart:typed_data';
import 'package:appflowy_theme_marketplace/src/plugins/data/firebase_repository/helpers/firestore_utils.dart';
import 'package:appflowy_theme_marketplace/src/plugins/data/firebase_repository/helpers/storage_utils.dart';
import 'package:archive/archive.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/user.dart';

class FirebasePluginRepository implements PluginRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _filesCollectionRef = _firestore.collection('Files');

  List<Plugin> toPlugin(List<QueryDocumentSnapshot<Object?>> objectEventsList) {
    final pluginsList = objectEventsList.map((object) {
      final fileMap = Map<String, dynamic>.from(object.data() as LinkedHashMap);
      User uploader = User(
        uid: fileMap['uploader']['uid'],
        email: fileMap['uploader']['email'] ?? 'Unknown',
        name: fileMap['uploader']['name'] ?? 'Unknown',
      );
      final DateTime time = fileMap['uploaded_on'].toDate();
      final Plugin zipFile = Plugin(
        pluginId: fileMap['plugin_id'],
        downloadCount: fileMap['download_count'],
        downloadURL: fileMap['downloadURL'],
        name: fileMap['name'],
        rating: fileMap['rating'],
        ratingCount: fileMap['ratingCount'],
        uploadDate: time,
        pickedFile: null,
        price: fileMap['price'],
        uploader: uploader,
      );
      return zipFile;
    }).toList();
    return pluginsList;
  }

  @override
  Future<void> add(Plugin plugin) async {
    if (plugin.pickedFile == null)
      throw Exception('no file is picked');
    await StorageUtils.uploadFile(plugin.pickedFile!.bytes, plugin.name, plugin.uploader, plugin.price);
  }

  @override
  Future<void> delete(Plugin plugin) => throw UnimplementedError();

  @override
  Future<Plugin> get(String id) => throw UnimplementedError();

  @override
  Future<List<Plugin>> list([String? searchTerm = '']) async {
    final list = await FireStoreUtils.listFiles(searchTerm);
    return toPlugin(list);
  }

  @override
  Future<Plugin> update(Plugin plugin) => throw UnimplementedError();

  @override
  Future<List<Plugin>> byDate([bool ascending = true]) async {
    final list = await FireStoreUtils.listFilesByDate();
    return toPlugin(list);
  }

  @override
  Future<List<Plugin>> byDownloadCount([bool ascending = true]) async {
    final list = await FireStoreUtils.listFilesByDownloadCount();
    return toPlugin(list);
  }

  @override
  Future<List<Plugin>> byName([bool ascending = true]) async {
    final list = await FireStoreUtils.listFilesByName();
    return toPlugin(list);
  }

  @override
  Future<List<Plugin>> byRatings([bool ascending = true]) async {
    final list = await FireStoreUtils.listFilesByRatings();
    return toPlugin(list);
  }
  
  @override
  Future<void> upload(Plugin plugin) {
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateDonloadCount(Plugin plugin) {
    throw UnimplementedError();
  }
}

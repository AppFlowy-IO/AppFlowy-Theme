import 'dart:collection';
import 'dart:typed_data';
import 'package:appflowy_theme_marketplace/src/plugins/data/firebase_repository/helpers/firestore_utils.dart';
import 'package:appflowy_theme_marketplace/src/plugins/data/firebase_repository/helpers/storage_utils.dart';
import 'package:archive/archive.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      // final Plugin zipFile = Plugin.upload(name: fileMap['name'], uploader: uploader, downloadURL: fileMap['downloadURL']);
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

  bool validateUploadFile(Uint8List bytes) {
    Archive archive = ZipDecoder().decodeBytes(bytes);

    // guarantee there must be two files light and dark no more or less
    if(archive.length != 2)
      return false;
    for (ArchiveFile file in archive) {
      if(file.isFile){
        final list = file.name.split('/');
        if(!list[0].endsWith('.plugin'))    // first directory must end with .plugin
          return false;
        if(!(list[1].endsWith('.light.json') || list[1].endsWith('.dark.json')))
          return false;
      }
    }
    return true;
  }

  @override
  Future<void> add(Plugin plugin) async {
    if(plugin.pickedFile == null)
      throw Exception('no file is picked');
    print(plugin.price);
    await StorageUtils.uploadFile(plugin.pickedFile!.bytes, plugin.name, plugin.uploader, plugin.price);
  }

  @override
  // TODO: implement delete
  Future<void> delete(Plugin plugin) => throw UnimplementedError();

  @override
  // TODO: implement get
  Future<Plugin> get(String id) => throw UnimplementedError();

  @override
  Future<List<Plugin>> list([String? searchTerm = '']) async {
    final list = await FireStoreUtils.listFiles(searchTerm);
    return toPlugin(list);
  }

  @override
  // TODO: implement update
  Future<Plugin> update(Plugin plugin) => throw UnimplementedError();

  @override
  Future<List<Plugin>> byDate([bool descending = true]) async {
    final list = await FireStoreUtils.listFilesByDate();
    return toPlugin(list);
  }

  @override
  Future<List<Plugin>> byDownloadCount([bool descending = true]) async {
    final list = await FireStoreUtils.listFilesByDownloadCount();
    return toPlugin(list);
  }

  @override
  Future<List<Plugin>> byName([bool descending = true]) async {
    final list = await FireStoreUtils.listFilesByName();
    return toPlugin(list);
  }

  @override
  Future<List<Plugin>> byRatings([bool descending = true]) async {
    final list = await FireStoreUtils.listFilesByRatings();
    return toPlugin(list);
  }
}

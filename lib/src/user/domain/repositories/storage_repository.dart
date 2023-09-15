
import 'dart:typed_data' as type;

import '../models/plugin.dart';
import '../models/plugin_file_object.dart';
import '../models/user.dart';

abstract class FileStorageRepository {
  Future<List<PluginFileObject>> get(String? searchTerm,String uid, String bucket);
  Future<void> add(Plugin plugin);
  Future<void> update(Plugin plugin);
  Future<List<PluginFileObject>> delete(String fileName, String bucket, String uid);
}
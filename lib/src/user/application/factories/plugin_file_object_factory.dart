import 'package:appflowy_theme_marketplace/src/user/domain/models/plugin_file_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PluginFileObjectFactory {
  static PluginFileObject fromFileObject(FileObject obj) {
    return PluginFileObject(
      name: obj.name,
      bucketId: obj.bucketId,
      owner: obj.owner,
      id: obj.id,
      updatedAt: obj.updatedAt,
      createdAt: obj.createdAt,
      lastAccessedAt: obj.lastAccessedAt,
      metadata: obj.metadata,
    );
  }
}
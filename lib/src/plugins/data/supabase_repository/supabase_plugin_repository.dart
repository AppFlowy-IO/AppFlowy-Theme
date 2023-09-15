import 'dart:typed_data';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';
import 'package:archive/archive.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../widgets/ui_utils.dart';

class SupabasePluginRepository implements PluginRepository {
  SupabasePluginRepository({supabase.SupabaseClient? sp, supabase.SupabaseStorageClient? storage})
    : sp = sp ?? supabase.Supabase.instance.client,
    storage = storage ?? supabase.Supabase.instance.client.storage;

  final supabase.SupabaseClient sp;
  final supabase.SupabaseStorageClient storage;

    static List<Plugin> toPlugin(List<dynamic> objectEventsList) {
      final pluginsList = objectEventsList.map((fileMap) {
        final Plugin zipFile = Plugin.fromJson(fileMap);
        return zipFile;
      }).toList();
      return pluginsList;
    }

    static bool validateUploadFile(Uint8List bytes) {
    late Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } on Exception catch(_) {
      return false;
    }

    // guarantee there must be two files light and dark no more or less
    if(archive.length != 2) {
      return false;
    }
    for (ArchiveFile file in archive) {
      if(file.isFile){
        final list = file.name.split('/');
        if(!list[0].endsWith('.plugin')) {
          return false;
        }
        if (!(list[1].endsWith(UiUtils.lightJsonTheme) || list[1].endsWith(UiUtils.darkJsonTheme))) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Future<void> add(Plugin plugin) async {
    if (plugin.pickedFile == null) {
      throw Exception('no file is picked');
    }
    
    if(plugin.pickedFile == null){
      throw Exception('picked file is undefined');
    }
    else {
      final filter = ProfanityFilter();
      if(filter.hasProfanity(plugin.name.toLowerCase().substring(0, plugin.name.lastIndexOf('.')))){
        throw Exception('Cannot upload file that has profanity');
      }
      if(plugin.pickedFile == null){
        throw Exception('Picked File is undefined');
      }
      if(!validateUploadFile(plugin.pickedFile!.bytes)){
        throw Exception('Does not meet the required format');
      }

      final String path = '${plugin.uploader.uid}/${plugin.name}';
      final bucket = plugin.price == 0 ? 'free_plugins' : 'paid_plugins';
      final String res = await storage.from(bucket).uploadBinary(
        path,
        plugin.pickedFile!.bytes,
         fileOptions:
            const supabase.FileOptions(
          contentType: 'application/zip',
        ),
      );
      if(res.isEmpty){
        throw Exception('Failed to upload file');
      }
      final String downloadUrl = plugin.price == 0 ? storage.from(bucket).getPublicUrl(path) : '';
      if(res.isNotEmpty) {
        final duplicate = await sp.from('files').select('*').eq('name', plugin.name).eq('price', plugin.price);
        if(duplicate.isNotEmpty){
          await storage.from(bucket).remove([path]);
          throw Exception('Exist plugin with the same data');
        }
        try {
          await sp.from('files').insert(Plugin.upload(
            name: plugin.name,
            uploader: plugin.uploader,
            price: plugin.price,
            downloadURL: downloadUrl,
          ).toJson());
        } on Exception catch(_) {
          await storage.from(bucket).remove([path]);
          rethrow;
        }
      }
      else {
        throw Exception('Error uploading plugin');
      }
    }
  
  }

  @override
  Future<List<Plugin>> byDate([bool ascending = false]) async {
    final data = await sp.from('files').select('*').order('created_at', ascending: ascending);
    final List<Plugin> plugins = toPlugin(data);
    return plugins;
  }

  @override
  Future<List<Plugin>> byDownloadCount([bool ascending = false]) async {
    final data = await sp.from('files').select('*').order('download_count', ascending: ascending);
    final List<Plugin> plugins = toPlugin(data);
    return plugins;
  }

  @override
  Future<List<Plugin>> byName([bool ascending = false]) async {
    final data = await sp.from('files').select('*').order('name', ascending: ascending);
    final List<Plugin> result = toPlugin(data);
    return result;
  }

  @override
  Future<List<Plugin>> byRatings([bool ascending = false]) async {
    final data = await sp.from('files').select('*').order('rating', ascending: ascending);
    final List<Plugin> plugins = toPlugin(data);
    return plugins;
  }

  @override
  Future<void> delete(Plugin plugin) {
    throw UnimplementedError();
  }

  @override
  Future<Plugin> get(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Plugin>> list([String? searchTerm = '']) async {
    late final List<Plugin> result;
    final data = await sp.from('files').select('*');
    result = toPlugin(data);
    if(searchTerm == null || searchTerm == '') {
      return result;
    } else {
      return result.where((item) => item.name.toLowerCase().contains(searchTerm)).toList();
    }
  }

  @override
  Future<void> update(Plugin plugin) async {
    await sp.from('files').update(plugin.toJson());
  }

  @override
  Future<void> updateDonloadCount(Plugin plugin) async {
    await sp.rpc(
      'increment_plugin_download_count',
      params: {
        'product_id': plugin.pluginId,
      },
    );
  }
}

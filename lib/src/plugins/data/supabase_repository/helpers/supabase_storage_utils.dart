import 'dart:typed_data';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseStorageUtils {
  static final sp = supabase.Supabase.instance.client;

  static bool validateUploadFile(Uint8List bytes) {
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

  static Future<void> uploadFile(Plugin plugin) async {
    if(plugin.pickedFile == null)
      throw Exception('picked file is undefined');
    else {
      final filter = ProfanityFilter();
      if(filter.hasProfanity(plugin.name.toLowerCase().substring(0, plugin.name.lastIndexOf('.'))))
        throw Exception('Cannot upload file that has profanity');
      if(plugin.pickedFile == null)
        throw Exception('Picked File is undefined');
      if(!validateUploadFile(plugin.pickedFile!.bytes))
        throw Exception('Does not meet the required format');

      final String path = '${plugin.uploader.uid}/${plugin.name}';
      final bucket = plugin.price == 0 ? 'free_plugins' : 'paid_plugins';
      final String res = await sp.storage.from(bucket).uploadBinary(
        path,
        plugin.pickedFile!.bytes,
         fileOptions:
            const supabase.FileOptions(
          contentType: 'application/zip',
        ),
      );
      if(res.isEmpty)
        throw Exception('Failed to upload file');
      final String downloadUrl = plugin.price == 0 ? sp.storage.from(bucket).getPublicUrl(path) : '';
      
      await sp.from('files').insert(Plugin.upload(
        name: plugin.name,
        uploader: plugin.uploader,
        price: plugin.price,
        downloadURL: downloadUrl,
      ).toJson());
    }
  }
  
  //TODO: implement a way to get tempoerary link
  static Future<String> getOneTimeUrl(Plugin plugin, String userId) async {
    final String path = '${plugin.uploader.uid}/${plugin.name}';
    const bucket = 'paid_plugins';
    final String downloadUrl = await sp.storage.from(bucket).createSignedUrl(path, 60);
    return downloadUrl;
  }
}
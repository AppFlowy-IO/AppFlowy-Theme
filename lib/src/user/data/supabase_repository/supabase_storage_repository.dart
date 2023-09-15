import 'dart:typed_data';
import 'package:appflowy_theme_marketplace/src/user/application/factories/plugin_file_object_factory.dart';
import 'package:archive/archive.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:profanity_filter/profanity_filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/ui_utils.dart';
import '../../domain/models/plugin.dart';
import '../../domain/models/plugin_file_object.dart';
import '../../domain/repositories/storage_repository.dart';

class SupabaseStorageRepository implements FileStorageRepository {
  SupabaseStorageRepository({supabase.SupabaseClient? sp, supabase.SupabaseStorageClient? storage})
      : sp = sp ?? supabase.Supabase.instance.client,
      storage = storage ?? supabase.Supabase.instance.client.storage;
  
  final supabase.SupabaseClient sp;
  final supabase.SupabaseStorageClient storage;

  static bool validateUploadFile(Uint8List bytes) {
    late Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } on Exception catch(_) {
      return false;
    }

    // guarantee there must be two files light and dark no more or less
    if (archive.length != 2) {
      return false;
    }
    for (ArchiveFile file in archive) {
      if (file.isFile){
        final list = file.name.split('/');
        if (!list[0].endsWith(UiUtils.plugins)) {
          return false;
        }
        if(!(list[1].endsWith(UiUtils.lightJsonTheme) || list[1].endsWith(UiUtils.darkJsonTheme))) {
          return false;
        }
      }
    }
    return true;
  }
  
  @override
  Future<List<PluginFileObject>> get(String? searchTerm, String uid, String bucket) async {
    List<PluginFileObject> fileObjList = [];
    const SearchOptions searchOptions = SearchOptions(
      sortBy: SortBy(
        column: 'updated_at',
        order: 'desc',
      ),
    );
    try {
      final List<FileObject> files = await storage
        .from(bucket)
        .list(
          path: uid,
          searchOptions: searchOptions
        );
      fileObjList = files
        .map((file) => PluginFileObjectFactory.fromFileObject(file))
        .toList();
      if (searchTerm != null && searchTerm.isNotEmpty) {
        fileObjList = fileObjList
          .where((file) => file.name.toLowerCase().contains(searchTerm))
          .toList();
      }
    } on Exception catch (e) {
      rethrow;
    }

    return fileObjList;
  }

  @override
  Future<void> add(Plugin plugin) async {
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
  Future<void> update(Plugin plugin) async {

  }

  @override
  Future<List<PluginFileObject>> delete(String fileName, String bucket, String uid) async {
    try {
      String path = '$uid/$fileName';
      final List<FileObject> filesObjects = await storage
        .from(bucket)
        .remove([path]);
      final List<PluginFileObject> files = filesObjects
        .map((file) => PluginFileObjectFactory.fromFileObject(file))
        .toList();
      if(filesObjects.isNotEmpty) {
        for(PluginFileObject deletedFile in files){
          String deletedFileName = deletedFile.name.split('/')[1];
          if(bucket == 'free_plugins') {
            await sp.from('files').delete().eq('name', deletedFileName).eq('price', 0);
          } else {
            await sp.from('files').delete().eq('name', deletedFileName).gt('price', 0);
          }
        }
      }
      return files;
    } on Exception catch(e) {
      if(e is StorageException){
        rethrow;
      }
      throw Exception('Something went wrong while deleteting file');
    }
  }
}

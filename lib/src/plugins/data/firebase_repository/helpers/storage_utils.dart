import 'dart:typed_data';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/pickedFile.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/user.dart';
import 'package:archive/archive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:profanity_filter/profanity_filter.dart';

import 'firestore_utils.dart';


class StorageUtils {
  String? _nextPageToken;
  StorageUtils(this._nextPageToken);

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

  static Future<void> uploadFile(Uint8List? byteFile, String? fileName, User? user, double price) async {
    if(byteFile != null && fileName != null && user != null){
      final filter = ProfanityFilter();
      if(filter.hasProfanity(fileName.toLowerCase().substring(0, fileName.lastIndexOf('.'))))
        throw Exception('Cannot upload file that has profanity');
      
      if(fileName.toLowerCase().substring(fileName.lastIndexOf('.')) != '.zip')
        throw Exception('$fileName is not a .zip file');

      if(!validateUploadFile(byteFile))
        throw Exception('Zip does not meet the required format');

      // final storage = FirebaseStorage.instance;
      // final ListResult listResultPrivate = await storage.ref('private').listAll();
      // List<Reference> privateList = listResultPrivate.items.where((item) => fileName == item.name).toList();
      // final ListResult listResultPublic = await storage.ref('public').listAll();
      // List<Reference> publicList = listResultPublic.items.where((item) => fileName == item.name).toList();
      
      // if(privateList.isNotEmpty || publicList.isNotEmpty)
      //   throw Exception('Exist file with the same name, please use a different name');
 
      // final List dupFile = await FireStoreUtils.listFiles(fileName);
      // if(dupFile.isNotEmpty)
      //   throw Exception('Exist file with the same name, please use a different name');

      String path = price == 0 ? 'public/${user.uid}' : 'private/${user.uid}';
      Reference storageReference = FirebaseStorage.instance.ref(path).child(fileName);

      SettableMetadata metadata = SettableMetadata(
        customMetadata: {
          'name': user.name ?? '',
          'uid': user.uid,
          'email': user.email ?? '',
        }
      );
      UploadTask uploadTask = storageReference.putData(byteFile, metadata);
      PickedFile pickedFile = PickedFile(byteFile, fileName);
      await uploadTask.whenComplete(() async {
        final String downloadURL = price == 0 ? await storageReference.getDownloadURL() : ''; 
        final Plugin plugin = Plugin.upload(
          pickedFile: pickedFile,
          name: fileName,
          uploader: user,
          downloadURL: downloadURL,
          price: price,
        );
        await FireStoreUtils.uploadFileData(plugin).catchError((err) => throw Exception(err));
      });
    } else if (byteFile == null) {
      throw Exception('byteFile cannot be null');
    } else if (fileName == null) {
      throw Exception('fileName cannot be null');
    } else if (user == null) {
      throw Exception('user cannot be null');
    } else {
      throw UnimplementedError('error from storage utils');
    }
  }
  
  //TODO: implement a way to get tempoerary link
  static Future<String> getOneTimeUrl(String fileName, String userId) async {
    Reference storageReference = FirebaseStorage.instance.ref('private/$fileName').child(fileName);
    final Uint8List? bytes = await storageReference.getData();
    return '';
  }

  static Future<List<Reference>> listAllFiles(String? searchTerm) async {
    final storage = FirebaseStorage.instance;
    
    try{
      if(searchTerm == null || searchTerm == ''){
        final ListResult listResult = await storage.ref().listAll();
        return listResult.items;
      }
      else{
        final ListResult listResult = await storage.ref().listAll();
        final List<Reference> filteredResult = listResult.items.where((item) => item.name.toLowerCase().contains(searchTerm)).toList();
        return filteredResult;
      }
    } on Exception catch(e) {
      Exception(e);
      return [];
    }
  }

  Future<List<Reference>> listByPage() async {
    final storage = FirebaseStorage.instance;

    final listResult = await storage.ref().list(
      ListOptions(
        maxResults: 10,
        pageToken: _nextPageToken,
      ),
    );
    setPageToken(listResult.nextPageToken);
    return listResult.items;
  }

  void setPageToken(String? pageToken){
    _nextPageToken = pageToken;
  }
}
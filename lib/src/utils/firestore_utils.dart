import 'dart:collection';

import 'package:appflowy_theme_marketplace/src/models/uploader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/plugin_zip_file.dart';
import '../models/rating.dart';

class FireStoreUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _filesCollectionRef = _firestore.collection('Files');
  static final CollectionReference _usersCollectionRef = _firestore.collection('Users');
  
  static Future<void> uploadFileData(PluginZipFile zipFile) async {
    final querySnapShot = await _filesCollectionRef.where('name', isEqualTo: zipFile.name).get();
    if(querySnapShot.docs.isNotEmpty)
      throw Exception('Duplicate file name in document');
    await _filesCollectionRef.doc().set(zipFile.toJson());
  }
  
  static Future<void> addNewUser(UploaderData user) async {
    final querySnapShot = await _usersCollectionRef.where('email', isEqualTo: user.email).get();
    if (querySnapShot.docs.isNotEmpty)
      throw Exception('Exist user with the same email address');
    await _usersCollectionRef.doc(user.uid).set(user.toJson());
  }

  //TODO: update user's info as there is any changes to the data
  static Future<void> updateUser(UploaderData user) async {
    try {
      DocumentSnapshot userDocument = await _getUserDocument(user.uid);
      String userDocId = userDocument.id;
      await _usersCollectionRef.doc(userDocId).update({
          'purchasedItems': user.purchasedItems,
          'stripeId': user.stripeId
        },
      );
    } on Exception catch(_) {
      rethrow;
    }
  }
    
  static Future<UploaderData> getUserData(String uid) async {
    try {
      DocumentSnapshot userDocument = await _getUserDocument(uid);
      final uploaderMap = Map<String, dynamic>.from(userDocument.data() as LinkedHashMap);
      final UploaderData uploader = UploaderData.fromJson(uploaderMap);
      return uploader;
    } on Exception catch(_) {
      rethrow;
    }
  }

  static Future<UploaderData> getUserDataByMail(String email) async {
    try {
      final QuerySnapshot querySnapshot = await _usersCollectionRef
        .where('email', isEqualTo: email)
        .get();
      final uploaderMap = Map<String, dynamic>.from(querySnapshot.docs[0].data() as LinkedHashMap);
      final UploaderData uploader = UploaderData.fromJson(uploaderMap);
      return uploader;
    } on Exception catch(_) {
      rethrow;
    }
  }

  static Future<DocumentSnapshot> _getUserDocument(String uid) async {
    try {
      final QuerySnapshot querySnapshot = await _usersCollectionRef
        .where('uid', isEqualTo: uid)
        .get();
      return querySnapshot.docs[0];
    } on Exception catch(_) {
      rethrow;
    }
  }

  static Future<void> addRating(String docId, Rating rating) async {
    final DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final CollectionReference ratingsCollectionRef = ratingsDocumentRef.collection('Ratings');
    UploaderData reviewer = UploaderData.fromJson(rating.reviewer);
    final QuerySnapshot querySnapshot = await ratingsCollectionRef
      .where('reviewer.email', isEqualTo: reviewer.email)
      .get();
    if(querySnapshot.docs.isEmpty){
      await ratingsCollectionRef.doc().set(rating.toJson());
      await _updateRating(docId);
    }
    else if(querySnapshot.docs.length > 1)
      throw Exception('Duplicate ratings for the same user in this file');
    else{
      await ratingsCollectionRef.doc(querySnapshot.docs[0].id).set(rating.toJson());
      await _updateRating(docId);
    }
  }

  static Future<void> _updateRating(String docId) async {
    final DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final CollectionReference ratingsCollectionRef = ratingsDocumentRef.collection('Ratings');
    final int countRating = await numRatings(docId);
    final double totalStars = await totalStarsRating(docId);
    final double avgRating = totalStars/countRating;
    await ratingsDocumentRef.update({'ratingCount': countRating, 'rating': double.parse((avgRating).toStringAsFixed(2))});
  }

  static Future<void> incrementDownloadCount(String docId) async {
    final DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final DocumentSnapshot<Object?> fileData = await ratingsDocumentRef.get();
    final fileMap = Map<String, dynamic>.from(fileData.data() as LinkedHashMap);
    PluginZipFile zipFile = PluginZipFile.fromJson(fileMap);
    await ratingsDocumentRef.update({'download_count': zipFile.downloadCount + 1});
  }
  
  static Future<int> numRatings(String docId) async {
    final DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final CollectionReference ratingsCollectionRef = ratingsDocumentRef.collection('Ratings');
    int countRatings = 0;
    
    try {
      await ratingsCollectionRef.get().then((event) {
        countRatings = event.docs.length;
      });
      return countRatings;
    } on Exception catch(_) {
      rethrow;
    }
  }
  
  static Future<double> totalStarsRating(String docId) async {
    final DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final CollectionReference ratingsCollectionRef = ratingsDocumentRef.collection('Ratings');
    int countRatings = 0;
    double totalStars = 0;
    try {
      final QuerySnapshot<Object?> snapshot = await ratingsCollectionRef.get();
      countRatings = snapshot.docs.length;
      for(final rating in snapshot.docs){
        double? rate = rating['rating'];
        if(rate == null)
          continue;
        totalStars += rate;
      }
      if (countRatings == 0) 
        return 1;
      return totalStars;
    } on Exception catch(_) {
      rethrow;
    }
  }

  //TODO: paginate the query instead of having all the result out
  static Future<List<QueryDocumentSnapshot<Object?>>> listFiles([String? searchTerm = '']) async {
    List<QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      QuerySnapshot<Object?> snapshot = await _filesCollectionRef.orderBy('name').get();
      objectEventsList = snapshot.docs;
      if(searchTerm != null || searchTerm == ''){
        objectEventsList = objectEventsList.where((item) => item['name'].toLowerCase().contains(searchTerm)).toList();
      }
      return objectEventsList;
    } on Exception catch(e) {
      return [];
    }
  }

  static Future<List<QueryDocumentSnapshot<Object?>>> listFilesByName([bool descending = true]) async {
    List<QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      await _filesCollectionRef.orderBy('name', descending: descending).get().then((event) {
        objectEventsList = event.docs;
      });
      return objectEventsList;
    } on Exception catch(e) {
      return [];
    }
  }

  static Future<List<QueryDocumentSnapshot<Object?>>> listFilesByDownloadCount([bool descending = true]) async {
    List<QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      await _filesCollectionRef.orderBy('download_count', descending: descending).get().then((event) {
        objectEventsList = event.docs;
      });
      return objectEventsList;
    } on Exception catch(e) {
      return [];
    }
  }

  static Future<List<QueryDocumentSnapshot<Object?>>> listFilesByRatings([bool descending = true]) async {
    List<QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      await _filesCollectionRef.orderBy('rating', descending: descending).get().then((event) {
        objectEventsList = event.docs;
      });
      return objectEventsList;
    } on Exception catch(e) {
      return [];
    }
  }

  static Future<List<QueryDocumentSnapshot<Object?>>> listFilesByDate([bool descending = true]) async {
    List<QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      await _filesCollectionRef.orderBy('uploaded_on', descending: descending).get().then((event) {
        objectEventsList = event.docs;
      });
      return objectEventsList;
    } on Exception catch(e) {
      return [];
    }
  }

  static Stream<QuerySnapshot> fileCollectionStream() {
    return _filesCollectionRef.snapshots();
  }

}
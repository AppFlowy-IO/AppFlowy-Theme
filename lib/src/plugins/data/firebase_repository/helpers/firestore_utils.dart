import 'dart:collection';

import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/rating.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;

class FireStoreUtils {
  static final firebase.FirebaseFirestore _firestore = firebase.FirebaseFirestore.instance;
  static final firebase.CollectionReference _filesCollectionRef = _firestore.collection('Files');
  static final firebase.CollectionReference _usersCollectionRef = _firestore.collection('Users');
  
  static Future<void> uploadFileData(Plugin plugin) async {
    final querySnapShot = await _filesCollectionRef.where('name', isEqualTo: plugin.name).get();
    if(querySnapShot.docs.isNotEmpty)
      throw Exception('Duplicate file name in document');
    await _filesCollectionRef.doc(plugin.pluginId).set(plugin.toJson());
  }

  static Future<void> addRating(String docId, Rating rating) async {
    final firebase.DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final firebase.CollectionReference ratingsCollectionRef = ratingsDocumentRef.collection('Ratings');
    User reviewer = rating.reviewer;
    print(reviewer.toJson());
    final firebase.QuerySnapshot querySnapshot = await ratingsCollectionRef
      .where('reviewer.email', isEqualTo: rating.reviewer.email)
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
    final firebase.DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final firebase.CollectionReference ratingsCollectionRef = ratingsDocumentRef.collection('Ratings');
    final int countRating = await numRatings(docId);
    final double totalStars = await totalStarsRating(docId);
    final double avgRating = totalStars/countRating;
    await ratingsDocumentRef.update({'ratingCount': countRating, 'rating': double.parse((avgRating).toStringAsFixed(2))});
  }

  static Future<void> incrementDownloadCount(String docId) async {
    final firebase.DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final firebase.DocumentSnapshot<Object?> fileData = await ratingsDocumentRef.get();
    final fileMap = Map<String, dynamic>.from(fileData.data() as LinkedHashMap);
    Plugin zipFile = Plugin.fromJson(fileMap);
    await ratingsDocumentRef.update({'download_count': zipFile.downloadCount + 1});
  }
  
  static Future<int> numRatings(String docId) async {
    final firebase.DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final firebase.CollectionReference ratingsCollectionRef = ratingsDocumentRef.collection('Ratings');
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
    final firebase.DocumentReference ratingsDocumentRef = _filesCollectionRef.doc(docId);
    final firebase.CollectionReference ratingsCollectionRef = ratingsDocumentRef.collection('Ratings');
    int countRatings = 0;
    double totalStars = 0;
    try {
      final firebase.QuerySnapshot<Object?> snapshot = await ratingsCollectionRef.get();
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
  static Future<List<firebase.QueryDocumentSnapshot<Object?>>> listFiles([String? searchTerm = '']) async {
    List<firebase.QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      firebase.QuerySnapshot<Object?> snapshot = await _filesCollectionRef.orderBy('name').get();
      objectEventsList = snapshot.docs;
      if(searchTerm != null || searchTerm == ''){
        objectEventsList = objectEventsList.where((item) => item['name'].toLowerCase().contains(searchTerm)).toList();
      }
      return objectEventsList;
    } on Exception catch(e) {
      return [];
    }
  }

  static Future<List<firebase.QueryDocumentSnapshot<Object?>>> listFilesByName([bool descending = true]) async {
    List<firebase.QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      await _filesCollectionRef.orderBy('name', descending: descending).get().then((event) {
        objectEventsList = event.docs;
      });
      return objectEventsList;
    } on Exception catch(e) {
      return [];
    }
  }

  static Future<List<firebase.QueryDocumentSnapshot<Object?>>> listFilesByDownloadCount([bool descending = true]) async {
    List<firebase.QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      await _filesCollectionRef.orderBy('download_count', descending: descending).get().then((event) {
        objectEventsList = event.docs;
      });
      return objectEventsList;
    } on Exception catch(e) {
      return [];
    }
  }

  static Future<List<firebase.QueryDocumentSnapshot<Object?>>> listFilesByRatings([bool descending = true]) async {
    List<firebase.QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      await _filesCollectionRef.orderBy('rating', descending: descending).get().then((event) {
        objectEventsList = event.docs;
      });
      return objectEventsList;
    } on Exception catch(_) {
      return [];
    }
  }

  static Future<List<firebase.QueryDocumentSnapshot<Object?>>> listFilesByDate([bool descending = true]) async {
    List<firebase.QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      await _filesCollectionRef.orderBy('uploaded_on', descending: descending).get().then((event) {
        objectEventsList = event.docs;
      });
      return objectEventsList;
    } on Exception catch(_) {
      return [];
    }
  }

  static Stream<firebase.QuerySnapshot> fileCollectionStream() {
    return _filesCollectionRef.snapshots();
  }

}
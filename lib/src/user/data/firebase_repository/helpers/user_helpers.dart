import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase;

import '../../../domain/models/user.dart';

class UserHelper {
  static final firebase.FirebaseFirestore _firestore = firebase.FirebaseFirestore.instance;
  static final firebase.CollectionReference _filesCollectionRef = _firestore.collection('Files');
  static final firebase.CollectionReference _usersCollectionRef = _firestore.collection('Users');

  static Future<void> addNewUser(User user) async {
    final querySnapShot = await _usersCollectionRef.where('email', isEqualTo: user.email).get();
    if (querySnapShot.docs.isNotEmpty)
      throw Exception('Exist user with the same email address');
    await _usersCollectionRef.doc(user.uid).set(user.toJson());
  }

  static Future<void> updateUser(User user) async {
    try {
      firebase.DocumentSnapshot userDocument = await _getUserDocument(user.uid);
      String userDocId = userDocument.id;
      await _usersCollectionRef.doc(userDocId).update({
          // 'purchasedItems': user.purchasedItems,
          // 'stripeId': user.stripeId
        },
      );
    } on Exception catch(_) {
      rethrow;
    }
  }

  static Future<firebase.DocumentSnapshot> _getUserDocument(String uid) async {
    try {
      final firebase.QuerySnapshot querySnapshot = await _usersCollectionRef
        .where('uid', isEqualTo: uid)
        .get();
      return querySnapshot.docs[0];
    } on Exception catch(_) {
      rethrow;
    }
  }
    
  static Future<User> getUserData(String uid) async {
    try {
      firebase.DocumentSnapshot userDocument = await _getUserDocument(uid);
      final uploaderMap = Map<String, dynamic>.from(userDocument.data() as LinkedHashMap);
      final User uploader = User.fromJson(uploaderMap);
      return uploader;
    } on Exception catch(_) {
      rethrow;
    }
  }

  static Future<User> getUserDataByMail(String email) async {
    try {
      final firebase.QuerySnapshot querySnapshot = await _usersCollectionRef
        .where('email', isEqualTo: email)
        .get();
      final uploaderMap = Map<String, dynamic>.from(querySnapshot.docs[0].data() as LinkedHashMap);
      final User uploader = User.fromJson(uploaderMap);
      return uploader;
    } on Exception catch(_) {
      rethrow;
    }
  }
}

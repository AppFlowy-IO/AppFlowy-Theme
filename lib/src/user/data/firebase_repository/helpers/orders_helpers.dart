import 'dart:collection';

import 'package:appflowy_theme_marketplace/src/user/domain/models/order.dart';
import 'package:appflowy_theme_marketplace/src/user/presentation/orders_page/orders_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:intl/intl.dart';

import '../../../domain/models/user.dart';

class OrdersHelper {
  static final firebase.FirebaseFirestore _firestore = firebase.FirebaseFirestore.instance;
  static final firebase.CollectionReference _usersCollectionRef = _firestore.collection('Users');

  static Future<List<Order>> getAll(String uid) async {
    final firebase.DocumentReference ordersDocumentRef = _usersCollectionRef.doc(uid);
    final firebase.CollectionReference ordersCollectionRef = ordersDocumentRef.collection('Orders');

    try {
      final firebase.QuerySnapshot querySnapshot = await ordersCollectionRef.get();
      List<Order> orders = querySnapshot.docs.map((orderDocument) {
        DateFormat inputFormat = DateFormat('M/d/yyyy');
        DateTime purchasedDate = inputFormat.parse(orderDocument['metadata']['purchaseDate']);
        final orderData = Order(
          customerUid: orderDocument['metadata']['customerUid'],
          productId: orderDocument['metadata']['productId'],
          productName: orderDocument['metadata']['productName'],
          purchaseDate: purchasedDate,
        );
        return orderData;
      }).toList();
      return orders;
    } on Exception catch(_) {
      rethrow;
    }
  }

  static Future<List<Order>> searchOrder(String uid, [String? searchTerm = '']) async {
    final firebase.DocumentReference ordersDocumentRef = _usersCollectionRef.doc(uid);
    final firebase.CollectionReference ordersCollectionRef = ordersDocumentRef.collection('Orders');
    List<firebase.QueryDocumentSnapshot<Object?>> objectEventsList = [];
    try{
      final firebase.QuerySnapshot querySnapshot = await ordersCollectionRef.get();
      objectEventsList = querySnapshot.docs;
      if (searchTerm != null || searchTerm != ''){
        objectEventsList = objectEventsList.where((item) => item['metadata']['productName'].toLowerCase().contains(searchTerm)).toList();
      }
      List<Order> orders = objectEventsList.map((orderDocument) {
        DateFormat inputFormat = DateFormat('M/d/yyyy');
        DateTime purchasedDate = inputFormat.parse(orderDocument['metadata']['purchaseDate']);
        final orderData = Order(
          customerUid: orderDocument['metadata']['customerUid'],
          productId: orderDocument['metadata']['productId'],
          productName: orderDocument['metadata']['productName'],
          purchaseDate: purchasedDate,
        );
        return orderData;
      }).toList();
      return orders;
    } on Exception catch(e) {
      return [];
    }
  }
}

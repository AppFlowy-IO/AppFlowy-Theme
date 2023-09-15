part of 'orders_bloc.dart';

abstract class OrdersEvent {
  const OrdersEvent();
}

class GetAllOrdersRequested extends OrdersEvent {
  const GetAllOrdersRequested(this.uid);

  final String uid;
}

class FindOrderRequested extends OrdersEvent {
  const FindOrderRequested(this.uid, this.productId);

  final String uid;
  final String productId;
}

class GetDownloadUrlRequested extends OrdersEvent {
  const GetDownloadUrlRequested(this.uid, this.productId);

  final String uid;
  final String productId;
}
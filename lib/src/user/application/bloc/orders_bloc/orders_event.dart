part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class GetAllOrdersRequested extends OrdersEvent {
  const GetAllOrdersRequested(this.uid);

  final String uid;

  @override
  List<Object> get props => [];
}

class FindOrderRequested extends OrdersEvent {
  const FindOrderRequested(this.uid, this.productId);

  final String uid;
  final String productId;

  @override
  List<Object> get props => [];
}
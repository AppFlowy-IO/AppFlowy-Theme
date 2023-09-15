part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
  
  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersLoading extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersLoaded extends OrdersState {
  const OrdersLoaded(this.orders);
  
  final List<Order> orders;

  @override
  List<Object> get props => [];
}

class OrdersUrlCreated extends OrdersState {
  const OrdersUrlCreated(this.url);
  
  final String url;

  @override
  List<Object> get props => [];
}

class OrdersLoadFailed extends OrdersState {
  const OrdersLoadFailed({required this.message});

  final String message;
  @override
  List<Object> get props => [];
}


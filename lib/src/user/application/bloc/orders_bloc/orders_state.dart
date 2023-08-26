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

class OrdersLoadFailed extends OrdersState {
  OrdersLoadFailed({message})
    : message = message.replaceAll('Exception: ', '');

  final String message;
  @override
  List<Object> get props => [];
}


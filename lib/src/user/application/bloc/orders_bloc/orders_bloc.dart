import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/order.dart';
import '../../../domain/repositories/orders_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository ordersRepository;
  OrdersBloc({
    required this.ordersRepository,
  }) : super(OrdersInitial()) {
    on<GetAllOrdersRequested>((event, emit) async {
      emit(OrdersLoading());
      await UiUtils.delayLoading();
      try {
        List<Order> orders = await ordersRepository.getAll(event.uid);
        emit(OrdersLoaded(orders));
      } on Exception catch (e) {
        debugPrint('failed $e');
        emit(OrdersLoadFailed(message: e));
      }
    });
    on<FindOrderRequested>((event, emit) async {
      emit(OrdersLoading());
      await UiUtils.delayLoading();
      try {
        List<Order> orders = await ordersRepository.searchOrder(event.uid, event.productId);
        emit(OrdersLoaded(orders));
      } on Exception catch (e) {
        debugPrint('failed $e');
        emit(OrdersLoadFailed(message: e));
      }
    });
  }
}

import 'package:appflowy_theme_marketplace/src/user/application/bloc/orders_bloc/orders_bloc.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../domain/models/order.dart';
import '../../domain/repositories/orders_repository.dart';
import 'orders_item.dart';

class OrdersBody extends StatefulWidget {
  const OrdersBody({super.key, required this.userStatus, required this.ordersRepository});
  
  final AuthenticateSuccess userStatus;
  final OrdersRepository ordersRepository;

  @override
  State<OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(FindOrderRequested(widget.userStatus.user!.uid, ''));
  }

  void showOrderDetail(Order order, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderDetail(order: order);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (BuildContext context, OrdersState state) {
          if (state is OrdersLoading) {
            return const CircularProgressIndicator();
          }
          if (state is OrdersLoaded) {
            return Column(
              children: [
                const Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: UiUtils.sizeXL,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * (1 / 3),
                  height: MediaQuery.of(context).size.height * (2 / 3),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: null,
                    itemCount: state.orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Order order = state.orders[index];
                      return ListTile(
                        enabled: true,
                        selected: index == _selectedIndex,
                        dense: false,
                        horizontalTitleGap: 0.0,
                        selectedColor: UiUtils.blue,
                        selectedTileColor: Colors.grey[800],
                        splashColor: UiUtils.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: UiUtils.sizeL),
                        leading: const SizedBox(
                          height: double.infinity,
                          child: Icon(Icons.file_copy),
                        ),
                        title: Text(order.productName),
                        subtitle: Text(order.productId),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          showOrderDetail(order, context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Text(state is OrdersLoadFailed ? state.message : state.toString());
        },
      ),
    );
  }
}
import 'package:appflowy_theme_marketplace/src/user/application/bloc/orders_bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import 'orders_item.dart';

class OrdersBody extends StatefulWidget {
  const OrdersBody({super.key, required this.userStatus});
  final AuthenticateSuccess userStatus;

  @override
  State<OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> {
  late List<Widget> fileContent;
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(FindOrderRequested(widget.userStatus.user!.uid, ''));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (BuildContext context, OrdersState state) {
          if(state is OrdersInitial)
            context.read<OrdersBloc>().add(GetAllOrdersRequested(widget.userStatus.user!.uid));
        },
        builder: (BuildContext context, OrdersState state) {
          if(state is OrdersLoading)
            return const CircularProgressIndicator();
          else if (state is OrdersLoaded) {
            return Container(
              width: MediaQuery.of(context).size.width * (1 / 3),
              height: MediaQuery.of(context).size.height * (2 / 3),
              color: Colors.grey[800],
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                controller: null,
                itemCount: state.orders.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = state.orders[index];
                  return ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return OrderDetail(order: order, uid: widget.userStatus.user!.uid);
                        },
                      );
                    },
                    title: Text(order.productName),
                  );
                },
              ),
            );
          }
          else {
            return Text(state is OrdersLoadFailed ? state.message : state.toString());
          }
        },
      ),
    );

  }
}
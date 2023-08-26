import 'package:appflowy_theme_marketplace/src/user/domain/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/bloc/orders_bloc/orders_bloc.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key, required this.order, required this.uid});
  final Order order;
  final String uid;

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 3),
      height: MediaQuery.of(context).size.height * (2 / 3),
      child: Column(
        children: [
          Text(widget.order.productName),
          Text(widget.order.productId),
          Text(widget.order.customerUid),
          Text(widget.order.purchaseDate.toString()),
        ],
      ),
    );
  }
}
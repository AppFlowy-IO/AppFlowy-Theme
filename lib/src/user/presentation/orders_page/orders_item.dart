import 'package:appflowy_theme_marketplace/src/user/domain/models/order.dart';
import 'package:flutter/material.dart';

import '../../../widgets/popup_dialog.dart';
import '../../../widgets/ui_utils.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key, required this.order});
  final Order order;

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
    return PopupDialog(
      title: Row(
        children: [
          const Text('Order details'),
          const Spacer(),
          IconButton(
            splashColor: UiUtils.transparent,
            splashRadius: UiUtils.sizeL,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * (1 / 3),
        height: MediaQuery.of(context).size.height * (2 / 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('plugin name: ${widget.order.productName}'),
            Text('plugin id: ${widget.order.productId}'),
            Text('customer id: ${widget.order.customerUid}'),
            Text('purchased date: ${widget.order.purchaseDate.toString()}'),
          ],
        ),
      ),
      actions: const [],
    );
  }
}
import 'package:appflowy_theme_marketplace/main.dart';
import 'package:appflowy_theme_marketplace/src/plugins/application/factories/plugin_factory.dart';
import 'package:appflowy_theme_marketplace/src/plugins/application/factories/user_factory.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/user/application/bloc/orders_bloc/orders_bloc.dart';
import 'package:appflowy_theme_marketplace/src/user/domain/repositories/orders_repository.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../payment/application/payment_bloc/payment_bloc.dart';
import '../../../application/plugin/plugin_bloc.dart';
import '../../../domain/models/order.dart';
import '../../../domain/models/user.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({super.key, required this.plugin, required this.user});

  final Plugin plugin;
  final User user;

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  List<Order> ordersList = [];
  bool _isLoading = true;
  
  Future<void> getUserOrders() async {
    _isLoading = true;
    await UiUtils.delayLoading(500);
    final List list = await getIt.get<OrdersRepository>().getAll(widget.user.uid);
    setState(() {
      ordersList = list.map((order) {
        return Order.fromJson(order.toJson());
      }).toList();
      _isLoading = false;
    });
  }

  bool canDownload(List<Order> orders) {
    bool isFree = widget.plugin.price == 0;
    bool isUploader = widget.plugin.uploader.uid == widget.user.uid;
    bool isPurchased = orders.any((order) => order.productId == widget.plugin.pluginId);
    return isFree || isUploader || isPurchased;
  }

  @override
  void initState() {
    super.initState();
    getUserOrders();
  }

  Future<void> downloadPlugin() async {
    final product = PluginFactory.toPayment(widget.plugin);
    final String downloadUrl = widget.plugin.downloadURL;
    if (downloadUrl.isNotEmpty) {
      context.read<PluginBloc>().add(IncrementDownloadCountRequested(widget.plugin));
      await launchUrl(Uri.parse(downloadUrl));
    }
    else {
      context.read<OrdersBloc>().add(GetDownloadUrlRequested(widget.user.uid, product.id));
    } 
  }

  Future<void> purchasePlugin(User user, ) async {
    final product = PluginFactory.toPayment(widget.plugin);
    context.read<PaymentBloc>().add(CheckOutSessionRequested(product, UserFactory.toPayment(user)));
  }

  @override
  Widget build(BuildContext context) {
    bool dowloadable = canDownload(ordersList);
    final String buttonText = dowloadable ? 'Download' : 'Purchase';

    final List<Widget> actions = <Widget>[
      TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        child: const Text('Complete'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];

    if (_isLoading){
      return AlertDialog(
        title: Text(buttonText),
        content: const TextButton(
          onPressed: null,
          child: CircularProgressIndicator(),
        ),
        actions: actions
      );
    }

    if (dowloadable){
      return BlocConsumer<OrdersBloc, OrdersState> (
        listener: (BuildContext context, OrdersState state) async {
          if (state is OrdersUrlCreated){
            context.read<PluginBloc>().add(IncrementDownloadCountRequested(widget.plugin));
            await launchUrl(Uri.parse(state.url));
          }
        },
        builder: (BuildContext context, OrdersState state) {
          if (state is OrdersLoading) {
            return AlertDialog(
              title: Text(buttonText),
              content: const TextButton(
                onPressed: null,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return AlertDialog(
            title: Text(buttonText),
            content: ElevatedButton(
              onPressed: () async {
                await downloadPlugin();
              },
              child: Text(buttonText),
            ),
            actions: actions
          );
        }
      );
    }

    else {
      return BlocBuilder<PaymentBloc, PaymentState>(
        builder: (BuildContext context, PaymentState state) {
          if (state is CreatingCheckoutSession) {
            return AlertDialog(
              title: Text(buttonText),
              content: const TextButton(
                onPressed: null,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return AlertDialog(
            title: Text(buttonText),
            content: ElevatedButton(
              onPressed: () async {
                await purchasePlugin(widget.user);
              },
              child: Text(buttonText),
            ),
            actions: actions
          );
        }
      );  
    }
  }
}
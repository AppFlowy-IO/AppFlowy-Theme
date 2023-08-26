import 'package:appflowy_theme_marketplace/src/payment/application/payment_bloc/payment_bloc.dart';
import 'package:appflowy_theme_marketplace/src/plugins/application/factories/user_factory.dart';
import 'package:appflowy_theme_marketplace/src/plugins/presentation/widgets/item_card/item_card_body.dart';
import 'package:appflowy_theme_marketplace/src/plugins/presentation/widgets/item_card/item_card_detail.dart';
import 'package:appflowy_theme_marketplace/src/widgets/error_dialog.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../../application/factories/plugin_factory.dart';
import '../../../domain/models/plugin.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.index, required this.file});

  final int index;
  final Plugin file;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isHovered = false;

  void _showPurchaseDialog(BuildContext context) {
    final AuthState userStatus = context.read<AuthBloc>().state;
    final product = PluginFactory.toPayment(widget.file);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<PaymentBloc, PaymentState>(
          builder: (BuildContext context, PaymentState state) {
            if(state is CreatingCheckoutSession) {
              return const AlertDialog(
                title: Text('purchase'),
                content: TextButton(
                  onPressed: null,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if(userStatus is AuthenticateSuccess){
              return AlertDialog(
                title: const Text('purchase'),
                content: ElevatedButton(
                  onPressed: () {
                    final authUser = userStatus.user;
                    final customer = UserFactory.toPayment(UserFactory.fromAuth(authUser!));
                    print(product.seller.toJson());
                    BlocProvider.of<PaymentBloc>(context).add(CheckOutSessionRequested(product, customer));
                  },
                  child: const Text('Purchase'),
                ),
                actions: <Widget>[
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
                ],
              );
            }
            else
              return const ErrorDialog('Please, Sign in to make purchase');
          }
        );
      },
    );
  }
  
  Widget build(BuildContext context) {
    final double screenSize = (MediaQuery.of(context).size.width - UiUtils.sizeXXL * 2);
    
    void showCardDetails() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ItemCardDetails(fileContent: widget.file);
        },
      );
    }
    
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: showCardDetails,
        child: Container(
          padding: const EdgeInsets.all(UiUtils.sizeS),
          width: UiUtils.calculateCardSize(screenSize),
          height: UiUtils.calculateCardSize(screenSize),
          child: AnimatedContainer(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, UiUtils.sizeS),
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(UiUtils.sizeS),
              boxShadow: [
                BoxShadow(
                  color: isHovered ? Colors.grey[700]! : Colors.black54,
                  offset: const Offset(UiUtils.sizeXS / 2, UiUtils.sizeXS / 2),
                  blurRadius: UiUtils.sizeXS / 2,
                  spreadRadius: UiUtils.sizeXS / 2,
                ),
              ],
            ),
            child: ItemCardBody(file: widget.file, showPurchaseDialog: _showPurchaseDialog),
          )
        )
      )
    );
  }
}
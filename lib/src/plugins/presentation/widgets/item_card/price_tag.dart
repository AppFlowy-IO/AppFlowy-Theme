import 'package:flutter/material.dart';
import '../../../../widgets/ui_utils.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price});
  final double price;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: UiUtils.sizeS,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: UiUtils.sizeM, vertical: UiUtils.sizeXS),
        decoration: const BoxDecoration(
          color: UiUtils.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UiUtils.sizeL),
            bottomLeft: Radius.circular(UiUtils.sizeL),
            topRight: Radius.zero,
            bottomRight: Radius.zero,
          ),
        ),
        child: Text(
          price == 0 ? 'Free' : '$price\$',
          style: const TextStyle(color: Colors.white, fontSize: UiUtils.sizeL),
        ),
      ),
    );
  }
}
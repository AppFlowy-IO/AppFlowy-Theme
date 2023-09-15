
import 'package:flutter/material.dart';
import 'ui_utils.dart';

class DefaulIconButton extends StatelessWidget {
  const DefaulIconButton({super.key, this.onPressed, required this.icon});

  final void Function()? onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      splashRadius: UiUtils.sizeXL,
      splashColor: UiUtils.transparent,
    );
  }
}
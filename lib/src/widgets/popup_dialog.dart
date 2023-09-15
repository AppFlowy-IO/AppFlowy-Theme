import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog({super.key, required this.content, required this.actions, required this.title});

  final Widget content;
  final Widget title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SelectionArea(child: title),
      content: SelectionArea(
        child: SingleChildScrollView(
          child: content,
        ),
      ),
      actions: actions,
    );
  }
}

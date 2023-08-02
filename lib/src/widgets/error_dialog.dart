import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(this.err, {super.key});

  final String err;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error Message'),
      content: Text(
        err,
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
          child: const Text('Understood'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

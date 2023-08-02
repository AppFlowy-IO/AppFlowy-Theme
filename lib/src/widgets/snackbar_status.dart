import 'package:flutter/material.dart';

class SnackbarSuccess extends SnackBar {
  SnackbarSuccess({
    Key? key,
    required String message,
    IconData iconData = Icons.check_circle,
  }) : super(
    key: key,
    content: Row(
      children: [
        Icon(
          iconData,
          color: Colors.white,
        ),
        Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ] 
    ),
    backgroundColor: Colors.green[400],
  );

}

class SnackbarError extends SnackBar {
  SnackbarError({
    Key? key,
    required String message,
    IconData iconData = Icons.error,
  }) : super(
    key: key,
    content: Row(
      children: [
        Icon(
          iconData,
          color: Colors.white,
        ),
        const SizedBox(width:8),
        Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    ),
    backgroundColor: Colors.red,
  );

}
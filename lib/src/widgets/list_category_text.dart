
import 'package:flutter/material.dart';

class ListCategoryText extends StatelessWidget {
  const ListCategoryText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Colors.grey,
        ),
      ),
    );
  }
}
import 'package:appflowy_theme_marketplace/src/widgets/upload_btn_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({super.key});

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      splashColor: Colors.transparent,
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => const UploadButtonModal()
      ),
      child: const Icon(Icons.upload),
    );
  }
}

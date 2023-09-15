import 'package:flutter/material.dart';
import '../../../../widgets/ui_utils.dart';
import './upload_btn_modal.dart';

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
      splashColor: UiUtils.transparent,
      onPressed: () =>
          showDialog<String>(context: context, builder: (BuildContext context) => const UploadButtonModal()),
      child: const Icon(Icons.upload),
    );
  }
}

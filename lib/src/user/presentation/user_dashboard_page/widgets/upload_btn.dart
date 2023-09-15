import 'package:flutter/material.dart';
import '../../../../widgets/ui_utils.dart';
import './upload_btn_modal.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          UiUtils.gray,
        ),
      ),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => const UploadButtonModal(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add, size: UiUtils.sizeL),
          SizedBox(width: UiUtils.sizeS),
          Text('Upload file'),
        ],
      ),
    );
  }
}

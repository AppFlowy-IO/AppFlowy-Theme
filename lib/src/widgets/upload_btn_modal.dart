import 'dart:typed_data';

import 'package:appflowy_theme_marketplace/src/blocs/auth_bloc/auth_state.dart';
import 'package:appflowy_theme_marketplace/src/blocs/db_bloc/db_event.dart';
import 'package:appflowy_theme_marketplace/src/utils/ui_utils.dart';
import 'package:appflowy_theme_marketplace/src/widgets/error_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:archive/archive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/db_bloc/db_bloc.dart';
import '../blocs/db_bloc/db_state.dart';
import 'snackbar_status.dart';

class UploadButtonModal extends StatefulWidget {
  const UploadButtonModal({super.key});

  @override
  State<UploadButtonModal> createState() => _UploadButtonModalState();
}

class _UploadButtonModalState extends State<UploadButtonModal> {
  PlatformFile? _uploadFile;
  double? price;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      setState(() {
        _uploadFile = result?.files.first;
      });
    } on Exception catch (_) {
      Navigator.pop(context);
      rethrow;
    }
  }

  //TODO: test this code when done with the folder select
  void zipFolder(Uint8List folder) async {
    try {
      Archive archive = ZipDecoder().decodeBytes(_uploadFile!.bytes!);
      final Uint8List fileBytes = ZipEncoder().encode(archive) as Uint8List;
      _uploadFile = PlatformFile(
          name: _uploadFile!.name, size: _uploadFile!.size, bytes: fileBytes);
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState =  context.read<AuthBloc>().state;
    late final User? user;
    if(userState is AuthenticateSuccess)
      user = userState.user;
    return AlertDialog(
      title: const Text('Upload file'),
      content: SizedBox(
        width: 400,
        height: 300,
        child: BlocConsumer<DbBloc, DbState>(
          builder: (BuildContext context, DbState state) {
            if (state is DbLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  OutlinedButton(
                    onPressed: () => _pickFile(),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      // overlayColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder,
                            size: UiUtils.sizeXL * 2,
                          ),
                          const SizedBox(height: UiUtils.sizeL),
                          Text(_uploadFile != null ? _uploadFile!.name : 'Select a zip file to upload'),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          enabled: false, // Disable input
                          controller: TextEditingController(
                            text: _uploadFile == null ? '' : _uploadFile?.name
                          ),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: UiUtils.sizeL),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: UiUtils.sizeM),
                          decoration: const InputDecoration(
                            labelText: 'price',
                            labelStyle: TextStyle(fontSize: UiUtils.sizeM),
                            suffixIcon: Icon(Icons.attach_money, size: UiUtils.sizeXL),
                          ),
                          onChanged: (value) => setState(() {
                            if(value == '')
                              price = null;
                            else{
                              try {
                                price = double.parse(value);
                              } on Exception catch (_) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ErrorDialog('Invalid price value');
                                  }
                                );
                                price = null;
                              }
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
          listener: (BuildContext context, DbState state) {
            if (state is DbUpdated) {
              Navigator.pop(context);
              final errorSnackbar = SnackbarSuccess(message: 'Upload Succeed');
              ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
            } else if (state is DbFailed) {
              context.read<DbBloc>().add(ResetStateRequested());
              Navigator.pop(context);
              final errorSnackbar = SnackbarError(message: state.message);
              ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
            }
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: (_uploadFile != null && user != null && price != null)
            ? () {
                context
                  .read<DbBloc>()
                  .add(UploadDataRequested(_uploadFile!, user!, price!));
              }
            : null,
          child: const Text('Upload'),
        ),
      ],
    );
  }
}


import 'package:appflowy_theme_marketplace/src/user/domain/models/plugin_file_object.dart';
import 'package:appflowy_theme_marketplace/src/widgets/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/snackbar_status.dart';
import '../../../../widgets/ui_utils.dart';
import '../../../application/bloc/storage_bloc/storage_bloc.dart';
import '../../../application/bloc/user_bloc/user_bloc.dart';

class DeleteFileForm extends StatelessWidget {
  const DeleteFileForm({super.key, required this.fileContent, required this.bucket});

  final PluginFileObject fileContent; 
  final String bucket;

  @override
  Widget build(BuildContext context) {
    final UserState userState = context.read<UserBloc>().state;
    
    return PopupDialog(
      content: BlocConsumer<StorageBloc, StorageState>(
        listener: (BuildContext context, StorageState state) {
          if (state is StorageDeleteSuccess) {
            Navigator.pop(context);
            final errorSnackbar = SnackbarSuccess(message: 'Delete Succeed');
            ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
          } else if (state is StorageFailed) {
            Navigator.pop(context);
            final errorSnackbar = SnackbarError(message: state.message);
            ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
          }
        },
        builder: (BuildContext context, StorageState state) {
          if (state is StorageDeletingFile) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SizedBox(
              child: Text(
                'Delete ${fileContent.name}',
              ),
            );
          }
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () {
            if (userState is UserLoaded) {
              context.read<StorageBloc>().add(
                DeleteFileRequested(
                  fileName: fileContent.name,
                  user: userState.user,
                  bucket: bucket,
                ),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(UiUtils.error),
            foregroundColor:
                MaterialStateProperty.all<Color>(UiUtils.white),
          ),
          child: const Text('Yes'),
        ),
      ],
      title: const Text('Are you Sure?'),
    );
  }
}
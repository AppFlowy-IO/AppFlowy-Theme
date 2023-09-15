import 'package:appflowy_theme_marketplace/src/plugins/application/plugin/plugin_bloc.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:appflowy_theme_marketplace/src/widgets/error_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../../../widgets/snackbar_status.dart';
import '../../../application/factories/user_factory.dart';
import '../../../domain/models/picked_file.dart';
import '../../../domain/models/user.dart';

class UploadButtonModal extends StatefulWidget {
  const UploadButtonModal({super.key});

  @override
  State<UploadButtonModal> createState() => _UploadButtonModalState();
}

class _UploadButtonModalState extends State<UploadButtonModal> {
  PickedFile? plugin;
  double? price;

  @override
  void dispose() {
    super.dispose();
  }

  Future<PickedFile> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    final bytes = result?.files.first.bytes;
    if (bytes == null) throw Exception('No file selected');
    return PickedFile(bytes, result!.files.first.name);
  }

  @override
  Widget build(BuildContext context) {
    final TextField priceInput = TextField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: UiUtils.sizeM),
      decoration: const InputDecoration(
        labelText: 'price',
        labelStyle: TextStyle(fontSize: UiUtils.sizeM),
        suffixIcon: Icon(Icons.attach_money, size: UiUtils.sizeXL),
      ),
      onChanged: (value) => setState(() {
        if (value == '')
          price = null;
        else {
          try {
            price = double.parse(value);
          } on Exception catch (_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const ErrorDialog(message: 'Invalid price value');
              });
            price = null;
          }
        }
      }),
    );

    final OutlinedButton uploadButtonArea = OutlinedButton(
      onPressed: () async {
        try {
          final pickedFile = await _pickFile();
          setState(() {
            plugin = pickedFile;
          });
        } on Exception catch(e) {
          debugPrint(e.toString());
        }
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
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
            Text(plugin != null ? plugin!.name : 'Select a zip file to upload'),
          ],
        ),
      ),
    );

    final Row uploadedFileInfo = Row(
      children: [
        Expanded(
          child: TextField(
            enabled: false, // Disable input
            controller: TextEditingController(text: plugin == null ? '' : plugin?.name),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: UiUtils.sizeL),
        SizedBox(
          width: 100,
          child: priceInput,
        ),
      ],
    );

    final AuthState userState = context.read<AuthBloc>().state;
    late final User? user;
    if (userState is AuthenticateSuccess){
      if (userState.user == null)
        throw Exception('user is undefined');
      user = UserFactory.fromAuth(userState.user!);
    }
    return AlertDialog(
      title: const Text('Upload file'),
      content: SizedBox(
        width: 400,
        height: 300,
        child: BlocConsumer<PluginBloc, PluginState>(
          builder: (BuildContext context, PluginState state) {
            if (state is PluginLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } 
            else {
              return Column(
                children: [
                  uploadButtonArea,
                  uploadedFileInfo,
                ],
              );
            }
          },
          listener: (BuildContext context, PluginState state) {
            if (state is PluginUpdated) {
              Navigator.pop(context);
              final errorSnackbar = SnackbarSuccess(message: 'Upload Succeed');
              ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
            } else if (state is PluginFailed) {
              context.read<PluginBloc>().add(ResetStateRequested());
              Navigator.pop(context);
              final errorSnackbar = SnackbarError(message: state.message);
              ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
            }
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: (plugin != null && user != null && price != null)
          ? () {
              if (user == null) return;
              context.read<PluginBloc>().add(UploadDataRequested(user, plugin!, price!));
            }
          : null,
          child: const Text('Upload'),
        ),
      ],
    );
  }
}

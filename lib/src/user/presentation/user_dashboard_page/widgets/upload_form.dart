import 'package:appflowy_theme_marketplace/src/plugins/application/plugin/plugin_bloc.dart';
import 'package:appflowy_theme_marketplace/src/widgets/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/ui_utils.dart';
import '../../../application/bloc/user_bloc/user_bloc.dart';
import '../../../domain/models/plugin_file_object.dart';
import '../../../domain/models/user.dart';

class UploadForm extends StatefulWidget {
  const UploadForm({super.key, required this.file});

  final PluginFileObject file;

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  @override
  Widget build(BuildContext context) {
    final UserState userState = context.read<UserBloc>().state;
    final dialogWidth = MediaQuery.of(context).size.width / 2;
    final dialogHeight = MediaQuery.of(context).size.height / 3;
    return PopupDialog(
      content: BlocBuilder<PluginBloc, PluginState>(
        builder: (context, state) {
          return SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Column(
              children: [
                
              ],
            ),
          );
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () {},
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

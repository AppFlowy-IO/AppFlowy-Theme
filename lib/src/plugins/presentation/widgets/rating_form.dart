import 'package:appflowy_theme_marketplace/src/authentication/application/auth_bloc/auth_bloc.dart';
import 'package:appflowy_theme_marketplace/src/plugins/application/factories/user_factory.dart';
import 'package:appflowy_theme_marketplace/src/plugins/application/plugin/plugin_bloc.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/user.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../widgets/error_dialog.dart';
import '../../../widgets/popup_dialog.dart';
import '../../../widgets/snackbar_status.dart';
import '../../domain/models/plugin.dart';
import '../../domain/models/rating.dart';

class RatingForm extends StatefulWidget {
  const RatingForm(this.plugin, this.rating, {super.key});
  final Plugin plugin;
  final double rating;

  @override
  State<RatingForm> createState() => _RatingFormState();
}

class _RatingFormState extends State<RatingForm> {
  late double rating;
  late String review;

  @override
  void initState() {
    super.initState();
    rating = widget.rating;
    review = '';
  }

  @override
  Widget build(BuildContext context) {
    final userStatus = context.read<AuthBloc>().state;
    final dialogWidth = MediaQuery.of(context).size.width / 2;
    final dialogHeight = MediaQuery.of(context).size.height / 3;
    const lineHeight = UiUtils.sizeXL;
    final maxLines = (dialogHeight / lineHeight).floor();

    if (userStatus is AuthenticateSuccess) {
      if (userStatus.user == null)
        throw Exception('user is undefined');
      final User reviewer = UserFactory.fromAuth(userStatus.user!);
      return PopupDialog(
        title: const Text('Rating'),
        content: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: BlocConsumer<PluginBloc, PluginState>(
            builder: (BuildContext context, PluginState state) {
              if (state is PluginLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Review',
                          textAlign: TextAlign.start,
                        ),
                        RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: UiUtils.sizeL,
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 0.0,
                          ),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (r) async {
                            setState(() {
                              rating = r;
                            });
                          },
                        ),
                      ],
                    ),
                    TextField(
                      maxLines: maxLines,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: UiUtils.sizeL),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: UiUtils.sizeL, horizontal: UiUtils.sizeL),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                              topRight: Radius.zero,
                              bottomRight: Radius.zero,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: UiUtils.blue,
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.black12),
                      onChanged: (value) {
                        review = value;
                      },
                    )
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
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Submit'),
            onPressed: () async {
              try {
                final Rating rate = Rating(
                  date: DateTime.now(),
                  rating: rating,
                  review: review,
                  reviewer: reviewer,
                  pluginId: widget.plugin.pluginId,
                  pluginName: widget.plugin.name,
                );
                context.read<PluginBloc>().add(AddRatingDataRequested(rate));
              } on Exception catch (e) {
                return showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(message: e.toString());
                  },
                );
              }
            },
          ),
        ],
      );
    }
    return const ErrorDialog(message: 'You must log in to add rating.');
  }
}

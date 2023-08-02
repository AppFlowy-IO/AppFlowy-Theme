import 'package:appflowy_theme_marketplace/src/models/uploader.dart';
import 'package:appflowy_theme_marketplace/src/blocs/auth_bloc/auth_bloc.dart';
import 'package:appflowy_theme_marketplace/src/blocs/db_bloc/db_event.dart';
import 'package:appflowy_theme_marketplace/src/utils/ui_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/rating.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../blocs/db_bloc/db_bloc.dart';
import '../blocs/db_bloc/db_state.dart';
import 'error_dialog.dart';
import 'snackbar_status.dart';

class RatingForm extends StatefulWidget {
  const RatingForm(this.docId, this.rating, {super.key});
  final String docId;
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
    final dialogWidth = MediaQuery.of(context).size.width/2;
    final dialogHeight = MediaQuery.of(context).size.height/3;
    const lineHeight = UiUtils.sizeXL;
    final maxLines = (dialogHeight / lineHeight).floor();

    
    if(userStatus is AuthenticateSuccess){
      final UploaderData reviewer = UploaderData(
        uid: userStatus.user!.uid,
        email: userStatus.user?.email,
        name: userStatus.user?.displayName
      );
      return AlertDialog(
        title: const Text('Rating'),
        content: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: BlocConsumer<DbBloc, DbState>(
            builder: (BuildContext context, DbState state) {
              if (state is DbLoading) {
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
                          itemPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0,),
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
                        fillColor: Colors.black12
                      ),
                      onChanged: (value) {
                        review = value;
                      },
                    )
                  ],
                );
              }
            },
            listener: (BuildContext context, DbState state) {
              if (state is DbUpdated) {
                Navigator.pop(context);
                final errorSnackbar = SnackbarSuccess(message: 'Upload Succeed');
                ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
              }
              else if (state is DbFailed) {
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
                  date: Timestamp.now(),
                  rating: rating,
                  review: review,
                  reviewer: reviewer.toJson(),
                );
                context.read<DbBloc>().add(AddRatingDataRequested(widget.docId, rate));
              } on Exception catch (e) {
                return showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(e.toString());
                  },
                );
              }
            },
          ),
        ],
      );
    }
    return const ErrorDialog('You must log in to add rating.');
  }
}
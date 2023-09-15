import 'package:flutter/material.dart';

import '../../../widgets/popup_dialog.dart';
import '../../../widgets/ui_utils.dart';
import '../../domain/models/rating.dart';

class RatingDetail extends StatefulWidget {
  const RatingDetail({super.key, required this.rating});
  final Rating rating;

  @override
  State<RatingDetail> createState() => _RatingDetailState();
}

class _RatingDetailState extends State<RatingDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      title: Row(
        children: [
          const Text('Order details'),
          const Spacer(),
          IconButton(
            splashColor: UiUtils.transparent,
            splashRadius: UiUtils.sizeL,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * (1 / 3),
        height: MediaQuery.of(context).size.height * (2 / 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('review date: ${widget.rating.date}'),
            Text('rating: ${widget.rating.rating}'),
            Text('review: ${widget.rating.review}'),
            Text('reviewer_email: ${widget.rating.reviewer.email}'),
            Text('reviewer_id: ${widget.rating.reviewer.uid}'),
            Text('plugin_id: ${widget.rating.pluginId}'),
          ],
        ),
      ),
      actions: const [],
    );
  }
}
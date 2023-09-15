import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'ui_utils.dart';

class StarRatingBar extends StatelessWidget {
  const StarRatingBar({super.key, required this.rating, this.onRatingUpdate});

  final double rating;
  final void Function(double)? onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      ignoreGestures: true,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: UiUtils.sizeM,
      itemPadding: const EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 0.0,
      ),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (r) {},
    );
  }
}
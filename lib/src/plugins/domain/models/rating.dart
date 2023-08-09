import 'package:appflowy_theme_marketplace/src/plugins/domain/models/user.dart';

class Rating {
  final DateTime date;
  final double rating;
  final String? review;
  final User reviewer;

  Rating({
    required this.date,
    required this.rating,
    this.review,
    required this.reviewer,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'rating': rating,
    'review': review ?? '',
    'reviewer': reviewer.toJson(),
  };
}
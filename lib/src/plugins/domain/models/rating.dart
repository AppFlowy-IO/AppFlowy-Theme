import 'package:appflowy_theme_marketplace/src/plugins/domain/models/user.dart';

class Rating {
  final DateTime date;
  final double rating;
  final String? review;
  final User reviewer;
  final String? pluginId;

  Rating({
    required this.date,
    required this.rating,
    this.review,
    required this.reviewer,
    this.pluginId,
  });

  factory Rating.insertRating(Rating rating, String pluginId) {
    return Rating(
      date: rating.date,
      rating: rating.rating,
      review: rating.review,
      reviewer: rating.reviewer,
      pluginId: pluginId,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'rating': rating,
    'review': review ?? '',
    'plugin_id': pluginId,
    'reviewer': reviewer.toJson(),
  };

  Map<String, dynamic> toJsonInsert() => {
    'review': review,
    'rating': rating,
    'reviewer_id': reviewer.uid,
    'plugin_id': pluginId,
    'reviewer_email': reviewer.email,
  };
}
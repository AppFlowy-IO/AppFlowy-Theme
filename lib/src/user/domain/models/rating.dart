import 'package:appflowy_theme_marketplace/src/plugins/domain/models/user.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';

class Rating {
  final DateTime date;
  final double rating;
  final String? review;
  final User reviewer;
  final String pluginId;
  final String? pluginName;

  Rating({
    required this.date,
    required this.rating,
    this.review,
    required this.reviewer,
    required this.pluginId,
    this.pluginName,
  });

  Rating.fromJson(Map<String, dynamic> object)
    : date = DateTime.parse(object['created_at']),
      rating = object['rating'],
      review = object['review'],
      pluginId = object['plugin_id'],
      pluginName = object['plugin_name'],
      reviewer = User(
        email: object['reviewer_email'],
        name: UiUtils.defaultUsername(object['reviewer_email']),
        uid: object['reviewer_id'],
      );

  Map<String, dynamic> toJson() => {
    'created_at': date,
    'rating': rating,
    'review': review ?? '',
    'plugin_id': pluginId,
    'plugin_name': pluginName,
    'reviewer_id': reviewer.uid,
    'reviewer_email': reviewer.email,
  };

  Map<String, dynamic> toJsonInsert() => {
    'review': review,
    'rating': rating,
    'reviewer_id': reviewer.uid,
    'plugin_id': pluginId,
    'reviewer_email': reviewer.email,
    'plugin_name': pluginName,
  };
}
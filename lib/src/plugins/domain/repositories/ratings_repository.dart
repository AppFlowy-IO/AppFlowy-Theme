import 'package:appflowy_theme_marketplace/src/plugins/domain/models/rating.dart';

abstract class RatingsRepository {
  Future<List<Rating>> getAll(String uid);
  Future<void> add(Rating rating);
  Future<void> update(Rating rating);
  Future<int> count(String ratingDocId);
  Future<double> average(String ratingDocId);
}

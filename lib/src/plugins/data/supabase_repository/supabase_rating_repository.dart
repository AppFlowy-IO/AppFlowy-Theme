import 'package:appflowy_theme_marketplace/src/plugins/domain/models/rating.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/ratings_repository.dart';

class SupabaseRatingsRepository implements RatingsRepository {
  @override
  Future<void> add(String pluginId, Rating rating) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<double> average(String ratingDocId) {
    // TODO: implement average
    throw UnimplementedError();
  }

  @override
  Future<int> count(String ratingDocId) {
    // TODO: implement count
    throw UnimplementedError();
  }

  @override
  Future<void> update(Rating rating) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}
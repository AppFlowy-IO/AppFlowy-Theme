import 'package:appflowy_theme_marketplace/src/plugins/domain/models/rating.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/ratings_repository.dart';

import 'helpers/firestore_utils.dart';

class FirebaseRatingsRepository implements RatingsRepository {
  @override
  Future<void> add(String pluginId, Rating rating) async {
    await FireStoreUtils.addRating(pluginId, rating);
  }

  @override
  Future<double> average(String ratingDocId) async {
    // TODO: implement average
    throw UnimplementedError();
  }

  @override
  Future<int> count(String ratingDocId) async {
    // TODO: implement count
    throw UnimplementedError();
  }

  @override
  Future<void> update(Rating rating) async {
    // TODO: implement update
    throw UnimplementedError();
  }

}
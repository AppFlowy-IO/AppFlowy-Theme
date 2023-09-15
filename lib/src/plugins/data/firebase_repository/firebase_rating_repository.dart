import 'package:appflowy_theme_marketplace/src/plugins/domain/models/rating.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/ratings_repository.dart';

import 'helpers/firestore_utils.dart';

class FirebaseRatingsRepository implements RatingsRepository {
  @override
  Future<List<Rating>> getAll(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<void> add(Rating rating) async {
    await FireStoreUtils.addRating(rating);
  }

  @override
  Future<double> average(String ratingDocId) async {
    throw UnimplementedError();
  }

  @override
  Future<int> count(String ratingDocId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> update(Rating rating) async {
    throw UnimplementedError();
  }
}
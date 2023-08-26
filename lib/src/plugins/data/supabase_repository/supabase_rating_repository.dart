import 'package:appflowy_theme_marketplace/src/plugins/domain/models/rating.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/ratings_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseRatingsRepository implements RatingsRepository {
  final sp = supabase.Supabase.instance.client;

  @override
  Future<void> add(String pluginId, Rating rating) async {
    await sp.from('ratings').upsert(Rating.insertRating(rating, pluginId).toJsonInsert());
  }

  @override
  Future<double> average(String ratingDocId) async {
    final value = await sp.from('ratings').select(
      'avg(rating)',
    );
    final double average = value;
    return average;
  }

  @override
  Future<int> count(String ratingDocId) async {
    final count = await sp.from('ratings').select(
      '*',
      const supabase.FetchOptions(
        count: supabase.CountOption.exact,
      ),
    );
    final int average = count;
    return average;
  }

  @override
  Future<void> update(Rating rating) async {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}
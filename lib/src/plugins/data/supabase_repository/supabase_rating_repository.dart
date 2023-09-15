import 'package:appflowy_theme_marketplace/src/plugins/domain/models/rating.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/ratings_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseRatingsRepository implements RatingsRepository {
  SupabaseRatingsRepository({supabase.SupabaseClient? sp}) : sp = sp ?? supabase.Supabase.instance.client;
  
  final supabase.SupabaseClient sp;

  @override
  Future<List<Rating>> getAll(String uid) async {
    List<Rating> ratings = [];
    final List data = await sp.from('ratings').select('*').eq('reviewer_id', uid);
    ratings = data.map((rating) {
      return Rating.fromJson(rating);
    }).toList();
    return ratings;
  }
  
  @override
  Future<void> add(Rating rating) async {
    await sp.from('ratings').upsert(rating.toJsonInsert());
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
    throw UnimplementedError();
  }
}
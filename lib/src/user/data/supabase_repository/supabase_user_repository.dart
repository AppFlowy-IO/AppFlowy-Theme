
import 'package:appflowy_theme_marketplace/src/user/domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseUserRepository implements UserRepository {
  final sp = supabase.Supabase.instance.client;
 
  @override
  Future<User> get(String id) async {
    // user can only get their own data anyway no need to filter by uid
    final data = await sp.from('users').select('*');
    User user = User(
      uid: data[0]['uid'],
      email: data[0]['email'],
      name: data[0]['name'],
      stripeId: data[0]['stripe_id']);
    return user;
  }
}
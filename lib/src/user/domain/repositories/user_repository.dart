import 'package:appflowy_theme_marketplace/src/user/domain/models/user.dart';

abstract class UserRepository {
  Future<User> get(String id);
  Future<String?> add(String email);
  Future<User> update(String stripeId);
}

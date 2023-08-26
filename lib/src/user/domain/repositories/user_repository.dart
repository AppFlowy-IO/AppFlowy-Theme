import 'package:appflowy_theme_marketplace/src/user/domain/models/user.dart';

abstract class UserRepository {
  Future<User> get(String id);
}

import 'package:appflowy_theme_marketplace/src/user/data/firebase_repository/helpers/user_helpers.dart';
import 'package:appflowy_theme_marketplace/src/user/domain/models/user.dart';

import '../../domain/repositories/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  @override
  Future<User> get(String id) async {
    User user = await UserHelper.getUserData(id);
    return user;
  }
  
  @override
  Future<String?> add(String email) {
    throw UnimplementedError();
  }
  
  @override
  Future<User> update(String stripeId) {
    throw UnimplementedError();
  }
}
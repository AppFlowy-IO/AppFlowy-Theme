import 'package:appflowy_theme_marketplace/src/user/domain/models/user.dart';
import 'package:appflowy_theme_marketplace/src/user/domain/repositories/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  @override
  Future<void> add(User user) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<User> byEmail(String email) {
    // TODO: implement byEmail
    throw UnimplementedError();
  }

  @override
  Future<User> get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> update(User user) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> create(User user) {
    // TODO: implement create
    throw UnimplementedError();
  }
  
}
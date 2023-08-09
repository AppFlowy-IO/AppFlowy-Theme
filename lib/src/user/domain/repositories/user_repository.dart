import '../models/user.dart';

abstract class UserRepository {
  Future<void> get(String id);
  Future<void> create(User user);
}

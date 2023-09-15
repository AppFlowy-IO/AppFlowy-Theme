import 'dart:async';

import '../models/user.dart';

abstract class AuthenticationRepository {
  Future<User?> register({required String emailAddress, required String password, String? name, required String key});
  Future<User?> signIn({required String emailAddress, required String password});
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Stream<User?> authStateChanges();
  Future<void> sendEmailVerification();
  Future<void> sendRecoveryEmail(String email);
}

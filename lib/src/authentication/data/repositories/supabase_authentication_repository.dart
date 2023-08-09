import 'dart:async';

import 'package:appflowy_theme_marketplace/src/authentication/domain/repositories/authentication_repository.dart';

import '../../domain/models/user.dart';

class SupabaseAuthenticationRepository implements AuthenticationRepository {
  @override
  Future<User?> register({required String emailAddress, required String password, String? name}) {
    throw UnimplementedError();
  }

  @override
  Future<User?> signIn({required String emailAddress, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
  
  @override
  Future<void> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }
  
  @override
  Stream<User?> authStateChanges() {
    // TODO: implement authStateChanges
    throw UnimplementedError();
  }
  
  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }
}

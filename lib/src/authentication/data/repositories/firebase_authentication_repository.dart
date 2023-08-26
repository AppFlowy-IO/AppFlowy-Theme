import 'dart:async';

import 'package:appflowy_theme_marketplace/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/models/user.dart';

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  firebase.User? currentUser;
  @override
  Future<User?> register({required String emailAddress, required String password, String? name}) async {
    try {
      final firebase.UserCredential credential = await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      final firebase.User? firebaseUser = credential.user;
      late User uploader;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name);
        uploader = User(uid: firebaseUser.uid, name: name, email: firebaseUser.email);
        // await userRepository.add(uploader); //create account from stripe and add to db
        currentUser = firebaseUser;
      } else {
        throw Exception('There is no user data');
      }
      return uploader;
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Exist an account with the given email.');
      }
    } on Exception catch (_) {
      rethrow;
    }
    return null;
  }

  @override
  Future<User?> signIn({required String emailAddress, required String password}) async {
    try {
      final credential =
          await firebase.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      final firebaseUser = credential.user;
      final User user = User(uid: firebaseUser!.uid, email: firebaseUser.email);
      return user;
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception('In correct email or password');
      }
      rethrow;
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    firebase.GoogleAuthProvider googleProvider = firebase.GoogleAuthProvider();
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
    try {
      await firebase.FirebaseAuth.instance.signInWithRedirect(googleProvider);
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebase.FirebaseAuth.instance.signOut();
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return firebase.FirebaseAuth.instance.authStateChanges().map(
      (firebaseUser) {
        if (firebaseUser == null) return null;
        User user = User(
          email: firebaseUser.email,
          uid: firebaseUser.uid,
          name: firebaseUser.displayName,
        );
        return user;
      },
    );
  }
  
  @override
  Future<void> sendEmailVerification() async {
    (currentUser != null)
        ? await currentUser!.sendEmailVerification()
        : throw Exception('user is null');
  }
}

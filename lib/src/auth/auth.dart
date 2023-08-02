import 'package:firebase_auth/firebase_auth.dart';

import '../models/uploader.dart';
import '../utils/firestore_utils.dart';

class Auth {
  static Future<User?> registerUser({required String emailAddress, required String password, String? name}) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      User? user = credential.user;
      if(user != null){
        await user.updateDisplayName(name);
        UploaderData uploader = UploaderData(uid: user.uid, name: name, email: user.email);
        await FireStoreUtils.addNewUser(uploader);
      }
      else
        throw Exception('There is no user data');
      return user;
    } on FirebaseAuthException catch (e) {
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

  static Future<User?> signIn({required String emailAddress, required String password}) async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception('In correct email or password');
      }
      rethrow;
    }
  }

  static Future<void> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
    try {
      await FirebaseAuth.instance.signInWithRedirect(googleProvider);
    } on Exception catch(_){
      rethrow;
    }
  }
  
  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on Exception catch(_){
      rethrow;
    }
  }
}

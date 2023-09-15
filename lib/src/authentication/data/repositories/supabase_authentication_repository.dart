import 'dart:async';
import 'dart:convert';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:http/http.dart' as http;
import 'package:appflowy_theme_marketplace/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../serverless_api/supabase_api.dart';
import '../../application/factories/supabase_signup_data.dart';
import '../../domain/models/user.dart';

class SupabaseAuthenticationRepository implements AuthenticationRepository {
  SupabaseAuthenticationRepository({supabase.GoTrueClient? auth, http.Client? client})
      : auth = auth ?? supabase.Supabase.instance.client.auth,
        client = client ?? http.Client();
  
  final supabase.GoTrueClient auth;
  final http.Client client;
  supabase.User? currentUser;
  
  @override
  Future<User?> register({required String emailAddress, required String password, String? name, required String key}) async {
    try {
      final supabase.AuthResponse res = await auth.signUp(
        email: emailAddress,
        password: password,
        data: SupabaseAuthSignUpData.fromSignInData(username: name, email: emailAddress).toJson()
      );
      final supabase.Session? session = res.session;
      final supabase.User? supabaseUser = res.user;
      late User uploader;
      if (supabaseUser != null) {
        uploader = User(uid: supabaseUser.id, name: name, email: supabaseUser.email);
        currentUser = supabaseUser;
      } else {
        throw Exception('There is no user data');
      }

      const url = SupabaseApi.createStripeAccount;
      final body = {
        'email': uploader.email
      };
      
      await client.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $key'
        },
        body: jsonEncode(body),
      );

      return uploader;
    } on Exception catch(_) {
      rethrow;
    }
  }

  @override
  Future<User?> signIn({required String emailAddress, required String password}) async {
    try {
      final supabase.AuthResponse res = await auth.signInWithPassword(
        email: emailAddress,
        password: password,
      );
      final supabase.Session? session = res.session;
      final supabase.User? supabaseUser = res.user;
      if(supabaseUser == null) {
        throw Exception('User is null');
      }
      final User user = User(uid: supabaseUser.id, email: supabaseUser.email);
      return user;
    } on Exception catch (_){
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on Exception catch (_) {
      rethrow;
    }
  }
  
  @override
  Future<void> signInWithGoogle() async{
    try {
      await auth.signInWithOAuth(supabase.Provider.google);
    } on Exception catch(_){
      rethrow;
    }
  }
  
  @override
  Stream<User?> authStateChanges() {
    return auth.onAuthStateChange.map(
      (supabase.AuthState state) {
        final supabase.Session? session = state.session;
        if (session == null) 
          return null;
        final String? email = session.user.email;
        if (email == null)
          throw Exception('user email is null');
        User user = User(
          email: session.user.email,
          uid: session.user.id,
          name: UiUtils.defaultUsername(email),
        );
        return user;
      },
    );
  }
  
  @override
  Future<void> sendEmailVerification() async {
    if (currentUser == null) 
      throw Exception('User is null');
    await auth.resend(type: supabase.OtpType.signup, email: currentUser!.email);
  }
  
  @override
  Future<void> sendRecoveryEmail(String email) async {
    await auth.resetPasswordForEmail(email, redirectTo: '${SupabaseApi.redirect_url}/password/reset');
    await Future.delayed(const Duration(milliseconds: 300), () {});
  }
}

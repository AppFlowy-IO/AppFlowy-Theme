
import 'dart:convert';

import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:http/http.dart' as http;
import '../../../serverless_api/supabase_api.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user.dart';

class SupabaseUserRepository implements UserRepository {
  SupabaseUserRepository({supabase.SupabaseClient? sp}) : sp = sp ?? supabase.Supabase.instance.client;
  
  final supabase.SupabaseClient sp;
  final key = dotenv.env['ANON_KEY'] as String;
 
  @override
  Future<User> get(String id) async {
    // user can only get their own data anyway so no need to filter by uid
    dynamic data = await sp.from('users').select('*');
    User user = User(
      uid: data[0]['uid'],
      email: data[0]['email'],
      name: data[0]['name'] ?? UiUtils.defaultUsername(data[0]['email']),
      stripeId: data[0]['stripe_id'],
      onboardCompleted: data[0]['onboarded'],
    );
    return user;
  }
  
  @override
  Future<String?> add(String email) async {
    http.Response? response;
    try {
      const url = SupabaseApi.createStripeAccount;
      final body = {
        'email': email,
      };
      response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $key'
        },
        body: jsonEncode(body),
      );

    } on Exception catch(e) {
      debugPrint(e.toString());
    }
    if (response == null)
      throw Exception('response is undefined');
    final result = json.decode(response.body);
    return result['id'];
  }
  
  @override
  Future<User> update(String stripeId) async {
    final String url = '${SupabaseApi.getStripeAccountInfo}/$stripeId';
    final stripeDataResponse = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'apikey': key,
        'Authorization': 'Bearer ${sp.auth.currentSession?.accessToken}',
      },
    );
    final stripeDataJson = json.decode(stripeDataResponse.body);
    final onboardCompleted = stripeDataJson['charges_enabled'];
    final response = await sp.from('users')
      .update({ 'onboarded': onboardCompleted })
      .eq('stripe_id', stripeId)
      .select();
    return User.fromJson(response[0]);
  }
}
import 'package:appflowy_theme_marketplace/src/payment/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/payment/domain/repositories/payment_repository.dart';
import 'package:appflowy_theme_marketplace/src/serverless_api/supabase_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../domain/models/user.dart';

class StripePaymentRepository implements PaymentRepository {

  @override
  Future<Map<String, dynamic>> createAccountLink(String email) async {
    const url = SupabaseApi.createStripeAccountLink;
    final body = {
      'email': email,
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {},
      body: body,
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData;
    } else
      throw Exception({
        'exitCode': response.statusCode,
      });
  }

  @override
  Future<Map<String, dynamic>> createInvoice(Plugin product, User customer) async {
    const url = SupabaseApi.stripeCheckoutSession;
    final key = dotenv.env['ANON_KEY'] as String;
    final body = {
      'name': product.name,
      'productId': product.id,
      'price': product.price.toString(),
      'uploaderEmail': product.seller.email,
      'uploaderName': product.seller.name,
      'description': 'some custom description',
      'customerUid': customer.uid,
    };
    
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $key',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData;
    } else
      throw Exception({'exitCode': response.statusCode, 'message': response.body});
  }
}

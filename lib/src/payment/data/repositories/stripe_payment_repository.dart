import 'dart:convert';
import 'dart:html' as html;

import 'package:appflowy_theme_marketplace/src/payment/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/payment/domain/repositories/payment_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class StripePaymentRepository implements PaymentRepository {
  static const API_URL = 'https://api.stripe.com/v1';
  static const API_KEY =
      'sk_test_51NVIBDBpcmnxPRNBePHmHtrWVc1FUYxqNskFSuEjx5MpFmmhV1gQW8M3tfLQIwDt5lK5Gijbdz6GubBCgg1Pl3pg00p36VPxs6';
  static const REDIRECT_URL = 'http://localhost:60162/#/';

  static const requestHeaders = {
    'Authorization': 'Bearer $API_KEY',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  static Map<String, dynamic> _formatResponse(Response response) {
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData;
    } else
      throw Exception({'exitCode': response.statusCode, 'message': response.body});
  }

  @override
  Future<Map<String, dynamic>> createAccount(String email) async {
    const url = '$API_URL/accounts';

    final body = {
      'type': 'standard',
      'country': 'US',
      'email': email,
    };

    final mathces = await findUser(email);
    if (mathces.isNotEmpty) {
      return mathces as Map<String, dynamic>;
    }

    final Response response = await http.post(
      Uri.parse(url),
      headers: requestHeaders,
      body: body,
    );

    final user = _formatResponse(response);

    final onBoardingLink = await createAccountLink(user['id']);
    html.window.location.assign(onBoardingLink['url']);
    launchUrl(onBoardingLink['url']);

    return user;
  }

  @override
  Future<Map<String, dynamic>> createAccountLink(String accountId) async {
    const url = 'https://api.stripe.com/v1/account_links';

    final headers = {
      'Authorization': 'Bearer $API_KEY',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {
      'account': accountId,
      'refresh_url': REDIRECT_URL, //TODO: properly track user's onboarding process
      'return_url': REDIRECT_URL, // TODO: look for 'charges_enabled: false,
      'type': 'account_onboarding',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData;
    } else
      throw Exception({'exitCode': response.statusCode, 'message': response.body});
  }

  @override
  Future<Map<String, dynamic>> createInvoice(String accountId, dynamic priceId, double cutPercentage) async {
    const url = 'https://makepurchase-udsncbzzwq-uc.a.run.app';
    final body = {
      'price': '15',
      'uploaderEmail': 'ellie@gmail.com',
      'uploaderImage': 'ellie',
      'cutPercentage': '10',
      'uid': 'FfpMaCb24WUywDArDnFgKGdYEE2',
    };

    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    // const url = '$API_URL/checkout/sessions';
    // final price = await getPriceDetails(priceId);
    // final cutAmount = cutPercentage / 100 * price['unit_amount'];

    // final headers = {
    //   'Authorization': 'Bearer $API_KEY',
    //   'Content-Type': 'application/x-www-form-urlencoded',
    // };

    // final body = {
    //   'mode': 'payment',
    //   'line_items[0][price]': priceId,
    //   'line_items[0][quantity]': '1',
    //   'payment_intent_data[application_fee_amount]': cutAmount.toString(),
    //   'payment_intent_data[transfer_data][destination]': accountId,
    //   'allow_promotion_codes': 'true',
    //   'success_url': REDIRECT_URL, //TODO: properly handle success and fail payment
    //   'cancel_url': REDIRECT_URL,
    // };

    // final response = await http.post(
    //   Uri.parse(url),
    //   headers: headers,
    //   body: body,
    // );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(priceId);
      return responseData;
    } else
      throw Exception({'exitCode': response.statusCode, 'message': response.body});
  }

  @override
  Future<Map<String, dynamic>> createProduct(Plugin product) async {
    const url = '$API_URL/products';

    final headers = {
      'Authorization': 'Bearer $API_KEY',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {
      'name': product.name,
      'description': 'No description',
      'default_price_data[unit_amount]': (product.price * 100).toString(),
      'default_price_data[currency]': 'usd',
      'expand[]': 'default_price',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData;
    } else
      throw Exception({'exitCode': response.statusCode, 'message': response.body});
  }

  @override
  Future<Map<String, dynamic>> createPrice(double amount, String productId) async {
    const url = '$API_URL/prices';

    final headers = {
      'Authorization': 'Bearer $API_KEY',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {
      'unit_amount': amount.toString(),
      'currency': 'usd',
      'product': productId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData;
    } else
      throw Exception({'exitCode': response.statusCode, 'message': response.body});
  }

  @override
  Future<Map<String, dynamic>> getPriceDetails(String priceId) async {
    final url = '$API_URL/prices/$priceId';

    final headers = {
      'Authorization': 'Bearer $API_KEY',
    };

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final priceData = jsonDecode(response.body) as Map<String, dynamic>;
      final price = priceData['unit_amount'];
      final currency = priceData['currency'];
      return priceData;
    } else {
      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    final url = '$API_URL/products/$productId';

    final response = await http.get(
      Uri.parse(url),
      headers: requestHeaders,
    );
    print(_formatResponse(response));
    return _formatResponse(response);
  }

  @override
  //TODO: implement delete product
  Future<Map<String, dynamic>> deleteProduct(String productId) async {
    final url = 'https://api.stripe.com/v1/products/$productId';

    final headers = {
      'Authorization': 'Bearer $API_KEY',
    };

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final priceData = jsonDecode(response.body) as Map<String, dynamic>;
      final price = priceData['unit_amount'];
      final currency = priceData['currency'];
      return priceData;
    } else {
      return {};
    }
  }

  //TODO: implement archive product
  @override
  Future<Map<String, dynamic>> archiveProduct(String productId) async {
    final url = 'https://api.stripe.com/v1/products/$productId';

    final headers = {
      'Authorization': 'Bearer $API_KEY',
    };

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final priceData = jsonDecode(response.body) as Map<String, dynamic>;
      final price = priceData['unit_amount'];
      final currency = priceData['currency'];
      return priceData;
    } else {
      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> getAllAccounts() async {
    const url = '$API_URL/accounts';
    final response = await http.get(
      Uri.parse(url),
      headers: requestHeaders,
    );
    return _formatResponse(response);
  }

  @override
  Future<Map<String, dynamic>> getUserAccount(String accountId) async {
    final url = '$API_URL/accounts/$accountId';
    final response = await http.get(
      Uri.parse(url),
      headers: requestHeaders,
    );
    return _formatResponse(response);
  }

  @override
  Future<Map> findUser(String email) async {
    final Map<String, dynamic> usersData = await getAllAccounts();
    final List usersList = usersData['data'];
    final List user = usersList.where((user) => user['email'] == email).toList();
    if (user.length > 1) throw Exception('There are more than one user with the same email');
    return user.isEmpty ? {} : user[0];
  }
}

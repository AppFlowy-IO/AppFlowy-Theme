import 'package:appflowy_theme_marketplace/src/payment/domain/models/plugin.dart';

import '../models/user.dart';


abstract class PaymentRepository {
  // Future<Map<String, dynamic>> createAccount(String email);
  Future<Map<String, dynamic>> createAccountLink(String accountId);
  Future<Map<String, dynamic>> createInvoice(Plugin product, User customer);
  // Future<Map<String, dynamic>> createProduct(Plugin fileContent);
  // Future<Map<String, dynamic>> createPrice(double amount, String productId);
  // Future<Map<String, dynamic>> getPriceDetails(String priceId);
  // Future<Map<String, dynamic>> getProductDetails(String productId);
  // Future<Map<String, dynamic>> deleteProduct(String productId);
  // Future<Map<String, dynamic>> archiveProduct(String productId);
  // Future<Map<String, dynamic>> getAllAccounts();
  // Future<Map<String, dynamic>> getUserAccount(String accountId);
  // Future<Map> findUser(String email);
}

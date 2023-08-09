import 'package:appflowy_theme_marketplace/src/payment/domain/models/plugin.dart';

abstract class PaymentRepository {
  // TODO: Create domain model for account
  Future<Map<String, dynamic>> createAccount(String email);
  // TODO: Create domain model for account link
  Future<Map<String, dynamic>> createAccountLink(String accountId);
  // TODO: Create domain model for invoice
  Future<Map<String, dynamic>> createInvoice(String accountId, dynamic priceId, double cutPercentage);
  // TODO: Create domain model for product
  Future<Map<String, dynamic>> createProduct(Plugin fileContent);
  // TODO: Create domain model for product price
  Future<Map<String, dynamic>> createPrice(double amount, String productId);
  Future<Map<String, dynamic>> getPriceDetails(String priceId);
  Future<Map<String, dynamic>> getProductDetails(String productId);
  Future<Map<String, dynamic>> deleteProduct(String productId);
  Future<Map<String, dynamic>> archiveProduct(String productId);
  Future<Map<String, dynamic>> getAllAccounts();
  Future<Map<String, dynamic>> getUserAccount(String accountId);
  Future<Map> findUser(String email);
}

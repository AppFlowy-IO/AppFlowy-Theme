import 'package:appflowy_theme_marketplace/src/payment/domain/models/plugin.dart';

import '../models/user.dart';


abstract class PaymentRepository {
  Future<Map<String, dynamic>> createAccountLink(String accountId);
  Future<Map<String, dynamic>> createInvoice(Plugin product, User customer);
}

import 'package:appflowy_theme_marketplace/src/user/domain/models/order.dart';

abstract class OrdersRepository {
  Future<List<Order>> getAll(String id);
  Future<List<Order>> searchOrder(String uid, String searchTerm);
  Future<String> getDownloadUrl(String customerId, String productId);
}
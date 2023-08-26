import 'package:appflowy_theme_marketplace/src/user/data/firebase_repository/helpers/orders_helpers.dart';
import 'package:appflowy_theme_marketplace/src/user/domain/models/order.dart';

import '../../domain/repositories/orders_repository.dart';

class FirebaseOrdersRepository implements OrdersRepository {
  @override
  Future<List<Order>> getAll(String id) async {
    final orders = await OrdersHelper.getAll(id);
    return orders;
  }
  
  @override
  Future<List<Order>> searchOrder(String uid, String searchTerm) async {
    final orders = await OrdersHelper.searchOrder(uid, searchTerm);
    return orders;
  }
}
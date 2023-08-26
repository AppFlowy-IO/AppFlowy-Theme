import 'package:intl/intl.dart';

import '../../domain/models/order.dart';
import '../../domain/repositories/orders_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseOrdersRepository implements OrdersRepository {
  final sp = supabase.Supabase.instance.client;
  
  @override
  Future<List<Order>> getAll(String uid) async{
    List<Order> orders = [];
    final data = await sp.from('users').select('*');
    orders = data.map((order) {
      return Order(
        customerUid: order['customer_id'],
        productId: order['plugin_id'],
        productName: order['product_name'],
        purchaseDate: DateTime.parse(order['created_at']),
      );
    }).toList();
    return orders;
  }
  
  @override
  Future<List<Order>> searchOrder(String uid, String searchTerm) async {
    List<Order> orders = [];
    final List<Map<String, dynamic>>  data = await sp.from('orders').select('plugin_id, created_at, product_name, customer_id');

    orders = data.map((order) {
      return Order(
        customerUid: order['customer_id'],
        productId: order['plugin_id'],
        productName: order['product_name'],
        purchaseDate: DateTime.parse(order['created_at']),
      );
    }).toList();
    return orders;
  }
}
  
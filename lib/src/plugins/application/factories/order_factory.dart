import 'package:appflowy_theme_marketplace/src/user/domain/models/order.dart' as user;

import '../../domain/models/order.dart';

class OrderFactory {
  static user.Order fromUser(Order order) {
    return user.Order.fromJson(order.toJson());
  }
}
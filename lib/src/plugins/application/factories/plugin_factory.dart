import 'package:appflowy_theme_marketplace/src/payment/domain/models/plugin.dart' as payment;
import '../../domain/models/plugin.dart';
import './user_factory.dart';

class PluginFactory {
  static payment.Plugin toPayment(Plugin plugin) {
    final seller = UserFactory.toPayment(plugin.uploader);
    return payment.Plugin(
      name: plugin.name,
      price: plugin.price,
      description: 'No description',
      id: plugin.pluginId,
      seller: seller,
    );
  }
}
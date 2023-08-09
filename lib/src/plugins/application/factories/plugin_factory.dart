import 'package:appflowy_theme_marketplace/src/payment/domain/models/plugin.dart' as payment;
import '../../domain/models/plugin.dart';

class PluginFactory {
  static payment.Plugin toPayment(Plugin plugin) {
    return payment.Plugin(
      price: plugin.price,
      description: 'No description',
      id: plugin.pluginId,
      name: plugin.name,
    );
  }
}
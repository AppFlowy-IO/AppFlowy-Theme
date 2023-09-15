import 'package:appflowy_theme_marketplace/src/payment/domain/models/plugin.dart' as payment;
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart' as plugins;
import '../../domain/models/plugin.dart';
import './user_factory.dart';

class PluginFactory {
  static payment.Plugin toPayment(Plugin plugin) {
    final seller = UserFactory.toPayment(plugin.uploader);
    return payment.Plugin(
      name: plugin.name,
      price: plugin.price,
      description: 'No description', //TODO:  might need to include description later
      id: plugin.pluginId,
      seller: seller,
    );
  }
 
  static plugins.Plugin toPlugins(Plugin plugin) {
    return plugins.Plugin.fromJson(plugin.toJson());
  }
}
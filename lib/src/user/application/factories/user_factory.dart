import '../../domain/models/user.dart';
import 'package:appflowy_theme_marketplace/src/authentication/domain/models/user.dart' as auth;
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/user.dart' as plugin;

class UserFactory {
  static User fromPlugin(plugin.User user) {
    return User(
      uid: user.uid,
      email: user.email ?? 'Unknown',
      name: user.name ?? 'Unknown',
    );
  }

  static plugin.User authToPlugin(auth.User user) {
    return plugin.User(
      uid: user.uid,
      email: user.email,
      name: user.name,
    );
  }


}

import 'package:appflowy_theme_marketplace/src/plugins/domain/models/user.dart' as plugin;

class User {
  final String uid;
  final String? name;
  final String email;
  final List purchasedItems;

  User({
    required this.uid,
    this.name,
    required this.email,
    List? purchasedItems,
  }) : purchasedItems = purchasedItems ?? [];

  factory User.fromPlugin(plugin.User user) {
    return User(
      uid: user.uid,
      email: user.email ?? 'Unknown',
      name: user.name ?? 'Unknown',
    );
  }

  User.fromJson(Map<String, dynamic> object)
      : uid = object['uid'] ?? '',
        name = object['name'] ?? '',
        email = object['email'] ?? '',
        purchasedItems = object['purchasedItems'] ?? [];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name ?? '',
        'email': email,
        'purchasedItems': purchasedItems,
      };
}

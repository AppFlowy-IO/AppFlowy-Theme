import 'user.dart';

class Plugin {
  final String name;
  final double price;
  final String description;
  final String id;
  final User seller;

  const Plugin({
    required this.name,
    required this.price,
    required this.description,
    required this.id,
    required this.seller,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'description': description,
    'id': id,
    'seller': seller.toJson(),
  };
}

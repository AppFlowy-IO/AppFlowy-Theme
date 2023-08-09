class User {
  final String uid;
  final String name;
  final String email;
  final String? stripeId;
  final List purchasedItems;

  User({
    required this.uid,
    required this.name,
    required this.email,
    this.stripeId,
    List? purchasedItems,
  }) : purchasedItems = purchasedItems ?? [];

  User.fromJson(Map<String, dynamic> object)
      : uid = object['uid'] ?? '',
        name = object['name'] ?? '',
        email = object['email'] ?? '',
        stripeId = object['stripeId'] ?? '',
        purchasedItems = object['purchasedItems'] ?? [];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'stripeId': stripeId ?? '',
        'purchasedItems': purchasedItems,
      };
}

class UploaderData {
  final String uid;
  final String? name;
  final String? email;
  final String? stripeId;
  final List purchasedItems;

  UploaderData({
    required this.uid,
    this.name,
    this.email,
    this.stripeId,
    List? purchasedItems,
  }) : purchasedItems = purchasedItems ?? [];

  UploaderData.fromJson(Map<String, dynamic> object)
    : uid = object['uid'] ?? '',
      name = object['name'] ?? '',
      email = object['email'] ?? '',
      stripeId = object['stripeId'] ?? '',
      purchasedItems = object['purchasedItems'] ?? [];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name ?? '',
    'email': email ?? '',
    'stripeId': stripeId ?? '',
    'purchasedItems': purchasedItems,
  };
}
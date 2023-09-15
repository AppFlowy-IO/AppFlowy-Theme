class User {
  final String uid;
  final String name;
  final String email;
  final String? stripeId;
  final bool onboardCompleted;

  User({
    required this.uid,
    required this.name,
    required this.email,
    this.stripeId,
    List? purchasedItems,
    bool? onboardCompleted,
  }) : onboardCompleted = onboardCompleted ?? false;
       

  User.fromJson(Map<String, dynamic> object)
      : uid = object['uid'],
        name = object['name'],
        email = object['email'],
        stripeId = object['stripeId'],
        onboardCompleted = object['onboardCompleted'] ?? false;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'stripeId': stripeId ?? '',
        'onboardCompleted': onboardCompleted,
      };
}

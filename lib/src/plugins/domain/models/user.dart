// TODO: This domain should have its own understanding of what a user is.
class User {
  final String uid;
  final String? name;
  final String? email;


  User({
    required this.uid,
    this.name,
    this.email,
  });

  User.fromJson(Map<String, dynamic> object)
      : uid = object['uid'] ?? '',
        name = object['name'] ?? '',
        email = object['email'] ?? '';

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name ?? '',
        'email': email ?? '',
      };
}

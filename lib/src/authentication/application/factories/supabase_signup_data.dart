// @freezed
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';

class SupabaseAuthSignUpData {
  SupabaseAuthSignUpData({
    required this.email, 
    this.username,
  });
  final String email;
  final String? username;

  factory SupabaseAuthSignUpData.fromSignInData({
    required String? username,
    required String email,
  }) {
    return SupabaseAuthSignUpData (username: username, email: email);
  }

  Map<String, dynamic> toJson() => {
    'username': username ?? UiUtils.defaultUsername(email),
  };
}
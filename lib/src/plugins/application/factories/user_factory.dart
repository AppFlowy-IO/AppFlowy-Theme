import '../../domain/models/user.dart';
import 'package:appflowy_theme_marketplace/src/authentication/domain/models/user.dart' as auth;
import 'package:appflowy_theme_marketplace/src/payment/domain/models/user.dart' as payment;

class UserFactory {
  static User fromAuth(auth.User user) {
    return User(
      uid: user.uid,
      email: user.email ?? 'Unknown',
      name: user.name ?? 'Unknown',
    );
  }

  static User fromPayment(payment.User user) {
    return User(
      uid: user.uid,
      email: user.email,
      name: user.name ?? '',
    );
  }

  static payment.User toPayment(User user) {
    return payment.User(
      uid: user.uid,
      name: user.name ?? 'Unknown',
      email: user.email ?? 'Unknown',
      stripeId: 'acct_1NcwEqBOBzdf6ybL',
      purchasedItems: [],
    );
  }
}

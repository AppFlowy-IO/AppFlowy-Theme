import 'package:appflowy_theme_marketplace/src/authentication/domain/models/user.dart' as auth_user;
import 'package:appflowy_theme_marketplace/src/payment/domain/repositories/payment_repository.dart' as flowy_payment;
import '../../plugins/domain/repositories/plugin_repository.dart' as flowy_db;
import 'package:appflowy_theme_marketplace/src/user/domain/models/user.dart';
import 'package:appflowy_theme_marketplace/src/user/domain/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:appflowy_theme_marketplace/src/authentication/domain/repositories/authentication_repository.dart';

class ApplicationUserRepository implements UserRepository {
  // final auth_user.AuthenticationRepository auth;
  final flowy_payment.PaymentRepository paymentRepository;
  final flowy_db.PluginRepository dbRepository;

  const ApplicationUserRepository({
    // required this.authRepository,
    required this.paymentRepository,
    required this.dbRepository,
  });

  @override
  Future<void> create(User user) async {
    // TODO: convert this domains User object into payment repo's User object
    // replace firebase's User? object with our firestore Uploader object

    // create the account in the payment system
    final paymentAccount = await paymentRepository.createAccount(user.email);

    // create user in database
    // auth_user.User(
    //   uid: const Uuid().v4(),
    //   email: user.email,
    //   name: user.name,
    // ).create(authRepository);

    // update firebase with stripe payment information
    // late final User uploader;
    // if (user != null) {
    //   uploader = User(uid: user.uid, email: user.email, name: user.displayName, stripeId: newAccount['id']);
    // }

    // update the user in firebase with the new credentials
    // await FireStoreUtils.updateUser(uploader);
  }

  @override
  Future<void> get(String id) {
    throw UnimplementedError();
  }
}

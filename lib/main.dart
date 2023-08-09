import 'package:appflowy_theme_marketplace/firebase_options.dart';
import 'package:appflowy_theme_marketplace/src/authentication/data/repositories/firebase_authentication_repository.dart';
import 'package:appflowy_theme_marketplace/src/payment/application/payment_bloc/payment_bloc.dart';
import 'package:appflowy_theme_marketplace/src/payment/data/repositories/stripe_payment_repository.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/ratings_repository.dart';
import 'package:appflowy_theme_marketplace/src/user/application/bloc/user_bloc.dart';
import 'package:appflowy_theme_marketplace/src/user/data/firebase_repository/firebase_user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'src/authentication/application/auth_bloc/auth_bloc.dart';
import 'src/authentication/presentation/signin_page/signin.dart';
import 'src/plugins/application/plugin/plugin_bloc.dart';
import 'src/plugins/data/firebase_repository/firebase_plugin_repository.dart';
import 'src/plugins/data/firebase_repository/firebase_rating_repository.dart';
import 'src/plugins/presentation/dashboard_page/dashboard.dart';
import 'src/user/domain/repositories/user_repository.dart';
import 'src/user/presentation/register_page/register.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  getIt.registerSingleton<PluginRepository>(FirebasePluginRepository());
  getIt.registerSingleton<RatingsRepository>(FirebaseRatingsRepository());
  getIt.registerSingleton<UserRepository>(FirebaseUserRepository());
  getIt.registerSingleton<FirebaseAuthenticationRepository>(FirebaseAuthenticationRepository());
  getIt.registerSingleton<StripePaymentRepository>(StripePaymentRepository());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(
            authenticationRepository:
                getIt.get<FirebaseAuthenticationRepository>(),
          ),
        ),
        BlocProvider<PluginBloc>(
          create: (BuildContext context) => PluginBloc(
            pluginRepository: getIt.get<PluginRepository>(),
            ratingsRepository: getIt.get<RatingsRepository>(),
          ),
        ),
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc(
            userRepository: getIt.get<UserRepository>(),
          ),
        ),
        BlocProvider<PaymentBloc>(
          create: (BuildContext context) => PaymentBloc(
              paymentRepository: getIt.get<StripePaymentRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Files Storage Manager',
        theme: ThemeData.dark().copyWith(
            // useMaterial3: true,
            // scaffoldBackgroundColor: const Color.fromARGB(255, 41, 45, 59),
            appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Dashboard(),
          '/signin': (context) => const SignIn(),
          '/register': (context) => const Register(),
        },
        // onGenerateRoute: (RouteSettings settings) {
        //   final uri = Uri.parse(settings.name!);
        //   final path = uri.path;
        //   if(path == '/'){
        //     return MaterialPageRoute(builder: (_) => const Dashboard());
        //   }
        //   else if(path == '/signin'){
        //     return MaterialPageRoute(builder: (_) => const SignIn());
        //   }
        //   else{
        //     return MaterialPageRoute(builder: (_) => const EmptyRoute());
        //   }
        // },
        scrollBehavior: MyCustomScrollBehavior(),
      ),
    ),
  );
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

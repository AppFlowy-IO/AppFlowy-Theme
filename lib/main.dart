import 'package:appflowy_theme_marketplace/src/payment/application/payment_bloc/payment_bloc.dart';
import 'package:appflowy_theme_marketplace/src/payment/data/repositories/stripe_payment_repository.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/ratings_repository.dart';
import 'package:appflowy_theme_marketplace/src/user/application/bloc/storage_bloc/storage_bloc.dart';
import 'package:appflowy_theme_marketplace/src/user/application/bloc/user_bloc/user_bloc.dart';
import 'package:appflowy_theme_marketplace/src/user/data/supabase_repository/supabase_storage_repository.dart';
import 'package:appflowy_theme_marketplace/src/user/domain/repositories/storage_repository.dart';
import 'package:appflowy_theme_marketplace/src/user/presentation/orders_page/orders_page.dart';
import 'package:appflowy_theme_marketplace/src/user/presentation/user_dashboard_page/user_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/authentication/application/auth_bloc/auth_bloc.dart';
import 'src/authentication/domain/repositories/authentication_repository.dart';
import 'src/authentication/presentation/signin_page/signin.dart';
import 'src/payment/domain/repositories/payment_repository.dart';
import 'src/plugins/application/plugin/plugin_bloc.dart';
import 'src/plugins/presentation/dashboard_page/dashboard_page.dart';
import 'src/serverless_api/supabase_api.dart';
import 'src/user/application/bloc/orders_bloc/orders_bloc.dart';
import 'src/plugins/data/supabase_repository/supabase_plugin_repository.dart';
import 'src/authentication/data/repositories/supabase_authentication_repository.dart';
import 'src/plugins/data/supabase_repository/supabase_rating_repository.dart';
import 'src/user/application/bloc/ratings_bloc/ratings_bloc.dart';
import 'src/user/data/supabase_repository/supabase_orders_repository.dart';
import 'src/user/data/supabase_repository/supabase_user_repository.dart';
import 'src/user/domain/repositories/orders_repository.dart';
import 'src/user/domain/repositories/user_repository.dart';
import 'src/user/presentation/ratings_page/ratings_page.dart';
import 'src/user/presentation/register_page/register.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/widgets/ui_utils.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'dotenv');
  await Supabase.initialize(
    url: SupabaseApi.supabaseUrl,
    anonKey: dotenv.env['ANON_KEY'] as String,
  );
  getIt.registerSingleton<PluginRepository>(SupabasePluginRepository());
  getIt.registerSingleton<RatingsRepository>(SupabaseRatingsRepository());
  getIt.registerSingleton<UserRepository>(SupabaseUserRepository());
  getIt.registerSingleton<OrdersRepository>(SupabaseOrdersRepository());
  getIt.registerSingleton<AuthenticationRepository>(SupabaseAuthenticationRepository());
  getIt.registerSingleton<PaymentRepository>(StripePaymentRepository());
  getIt.registerSingleton<FileStorageRepository>(SupabaseStorageRepository());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(
            authenticationRepository: getIt.get<AuthenticationRepository>(),
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
        BlocProvider<RatingsBloc>(
          create: (BuildContext context) => RatingsBloc(
            ratingsRepository: getIt.get<RatingsRepository>(),
          ),
        ),
        BlocProvider<OrdersBloc>(
          create: (BuildContext context) => OrdersBloc(
            ordersRepository: getIt.get<OrdersRepository>(),
          ),
        ),
        BlocProvider<PaymentBloc>(
          create: (BuildContext context) => PaymentBloc(
              paymentRepository: getIt.get<PaymentRepository>()),
        ),
        BlocProvider<StorageBloc>(
          create: (BuildContext context) => StorageBloc(
              storageRepository: getIt.get<FileStorageRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Files Storage Manager',
        theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: UiUtils.transparent,
            elevation: 0,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => DashboardPage(pluginRepository: getIt.get<PluginRepository>()),
          '/signin': (context) => const SignInPage(),
          '/register': (context) => const RegisterPage(),
          '/ratings': (context) => RatingsPage(ratingsRepository: getIt.get<RatingsRepository>()),
          '/orders': (context) => OrdersPage(ordersRepository: getIt.get<OrdersRepository>()),
          '/user/plugins': (context) => UserDashboardPage(userRepository: getIt.get<UserRepository>()),
        },
      ),
    ),
  );
}
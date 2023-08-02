import 'package:appflowy_theme_marketplace/firebase_options.dart';
import 'package:appflowy_theme_marketplace/src/blocs/db_bloc/db_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/blocs/auth_bloc/auth_bloc.dart';
import 'src/pages/dashboard_page/dashboard.dart';
import 'src/pages/register_page/register.dart';
import 'src/pages/signin_page/signin.dart';
import 'src/pages/empty_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        ),
        BlocProvider<DbBloc>(
          create: (BuildContext context) => DbBloc(),
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

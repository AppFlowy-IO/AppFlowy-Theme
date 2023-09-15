import 'package:appflowy_theme_marketplace/src/user/application/factories/user_factory.dart';
import 'package:appflowy_theme_marketplace/src/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_dashboard_body.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key, required this.userRepository});
  
  final UserRepository userRepository;

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _drawerContent = const SizedBox();

  void openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void setDrawerContent(Widget content) {
    setState(() {
      _drawerContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      scaffoldKey: _scaffoldKey,
      drawerContent: _drawerContent,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (state is! AuthenticateSuccess) {
            return const SizedBox();
          }
          final user = state.user;
          if (user == null) {
            throw Exception('user is not defined');
          }
          return UserDashboardBody(
            openDrawer: openDrawer,
            user: UserFactory.fromAuth(user),
            userRepository: widget.userRepository,
            setDrawerContent: setDrawerContent,
          );
        },
      ),
    );
  }
}

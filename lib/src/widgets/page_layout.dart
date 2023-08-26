import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication/application/auth_bloc/auth_bloc.dart';
import '../plugins/presentation/widgets/user_dropdown/user_dropdown.dart';
import '../user/application/factories/user_factory.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    String appTitle = screenSize > 800 ? 'Appflowy Marketplace' : '';
    return Scaffold(
      appBar: AppBar(
        leading: null,
        centerTitle: true,
        toolbarHeight: 80,
        title: Row(
          children: [
            const Icon(Icons.extension_sharp),
            const SizedBox(width: 8),
            Text(
              appTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(UiUtils.sizeS),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, AuthState state) {
                if (state is Loading) {
                  return TextButton(
                    onPressed: () => {},
                    child: const CircularProgressIndicator(),
                  );
                }
                else if (state is UnAuthenticated || state is RegistrationSuccess) {
                  return TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signin'),
                    child: const Text('Signin'),
                  );
                } else if (state is AuthenticateSuccess) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 0,
                    ),
                    width: 80,
                    child: UserDropDown(
                      user: UserFactory.authToPlugin(state.user!),
                    ),
                  );
                } else {
                  return const Text('Error');
                }
              },
            ),
          ),
        ],
      ),
      body: body,
    );
  }
}
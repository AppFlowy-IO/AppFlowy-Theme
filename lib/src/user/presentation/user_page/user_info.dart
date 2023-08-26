import 'package:appflowy_theme_marketplace/src/user/application/factories/user_factory.dart';
import 'package:appflowy_theme_marketplace/src/plugins/presentation/widgets/user_dropdown/user_dropdown.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main.dart';
import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../../plugins/application/search/plugin_search_bloc.dart';
import '../../../plugins/domain/repositories/plugin_repository.dart';
import '../../../plugins/presentation/widgets/search_input.dart';
import 'user_body.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

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
            const SearchInput(),
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
      body: const UserBody(),
    );
  }
}

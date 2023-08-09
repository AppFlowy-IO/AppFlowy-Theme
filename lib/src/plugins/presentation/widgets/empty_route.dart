import 'package:appflowy_theme_marketplace/main.dart';
import 'package:appflowy_theme_marketplace/src/plugins/application/search/plugin_search_bloc.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import 'upload_btn.dart';
import 'search_input.dart';

class EmptyRoute extends StatelessWidget {
  const EmptyRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    String appTitle = screenSize > 800 ? 'Appflowy Marketplace' : '';
    final AuthState userStatus = context.read<AuthBloc>().state;

    return BlocProvider<PluginSearchBloc>(
      create: (BuildContext context) => PluginSearchBloc(
        pluginRepository: getIt.get<PluginRepository>(),
      ),
      child: Scaffold(
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
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (BuildContext context, AuthState state) {
                    if (state is UnAuthenticated) {
                      return TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/signin'),
                        child: const Text('Login'),
                      );
                    } else if (state is AuthenticateSuccess) {
                      return TextButton(
                        onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
                        child: const Text('Logout'),
                      );
                    } else {
                      return const Text('error');
                    }
                  },
                ),
              ),
            ]),
        body: const Text('This page does not exist.'),
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState state) {
            if (state is AuthenticateSuccess)
              return const UploadButton();
            else
              return const SizedBox();
          },
        ),
      ),
    );
  }
}

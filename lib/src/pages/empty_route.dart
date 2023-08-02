import 'package:appflowy_theme_marketplace/src/blocs/auth_bloc/auth_state.dart';
import 'package:appflowy_theme_marketplace/src/widgets/search_input.dart';
import 'package:appflowy_theme_marketplace/src/widgets/upload_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/search_file_bloc/search_file_bloc.dart';

class EmptyRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    String appTitle = screenSize > 800 ? 'Appflowy Marketplace' : '';
    final AuthState userStatus = context.read<AuthBloc>().state;
    final bool isAuthenticated = userStatus is AuthenticateSuccess;
    
    return BlocProvider<SearchFilesBloc>(
      create: (BuildContext context) => SearchFilesBloc(),
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
          ]
        ),
        body: const Text('This page does not exist.'),
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState state) {
            if(state is AuthenticateSuccess)
              return const UploadButton();
            else
              return const SizedBox();
          },
        ),
      ),
    );
  }
}
import 'package:appflowy_theme_marketplace/src/blocs/auth_bloc/auth_state.dart';
import 'package:appflowy_theme_marketplace/src/utils/ui_utils.dart';
import 'package:appflowy_theme_marketplace/src/widgets/search_input.dart';
import 'package:appflowy_theme_marketplace/src/widgets/upload_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:html' as html;

import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../blocs/search_file_bloc/search_file_bloc.dart';
import '../../models/plugin_zip_file.dart';
import '../../models/uploader.dart';
import '../../payment/stripe.dart';
import 'dashboard_body.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    String appTitle = screenSize > 800 ? 'Appflowy Marketplace' : '';
    
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
              padding: const EdgeInsets.all(UiUtils.sizeS),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (BuildContext context, AuthState state) {
                  if (state is Loading) {
                    return TextButton(
                      onPressed: () => {},
                      child: const CircularProgressIndicator(),
                    );
                  }
                  else if (state is UnAuthenticated) {
                    return TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signin'),
                      child: const Text('Signin'),
                    );
                  } else if (state is AuthenticateSuccess) {
                    return TextButton(
                      onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
                      child: const Text('Signout'),
                    );
                  } else {
                    return const Text('Error');
                  }
                },
              ),
            ),
          ]
        ),
        body: const DashboardBody(),
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
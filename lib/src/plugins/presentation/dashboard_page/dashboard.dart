import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../application/search/plugin_search_bloc.dart';
import '../../data/firebase_repository/firebase_plugin_repository.dart';
import '../widgets/upload_btn.dart';
import '../widgets/search_input.dart';
import 'dashboard_body.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    String appTitle = screenSize > 800 ? 'Appflowy Marketplace' : '';
    FirebasePluginRepository firebasePluginRepo = FirebasePluginRepository();
    return BlocProvider<PluginSearchBloc>(
      create: (BuildContext context) => PluginSearchBloc(pluginRepository: firebasePluginRepo),
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
                  } else if (state is UnAuthenticated) {
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
          ],
        ),
        // body: Container(color: Colors.green, width: double.infinity,),
        body: const DashboardBody(),
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

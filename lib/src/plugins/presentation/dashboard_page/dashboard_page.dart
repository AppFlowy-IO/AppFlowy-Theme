import 'package:appflowy_theme_marketplace/src/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../application/search/plugin_search_bloc.dart';
import '../../domain/repositories/plugin_repository.dart';
import '../widgets/upload_btn/upload_btn.dart';
import 'dashboard_body.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.pluginRepository});

  final PluginRepository pluginRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PluginSearchBloc>(
      create: (BuildContext context) => PluginSearchBloc(pluginRepository: pluginRepository),
      child: PageLayout(
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

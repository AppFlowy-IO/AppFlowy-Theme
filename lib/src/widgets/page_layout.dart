import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication/application/auth_bloc/auth_bloc.dart';
import '../plugins/presentation/widgets/search_input.dart';
import '../plugins/presentation/widgets/user_dropdown/user_dropdown.dart';
import '../user/application/factories/user_factory.dart';
import 'hover_opacity_widget.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({
    super.key,
    this.body,
    this.floatingActionButton,
    this.drawerContent,
    this.scaffoldKey,
  });

  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? drawerContent;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final curRoute = ModalRoute.of(context)?.settings.name;
    final screenSize = MediaQuery.of(context).size.width;
    String appTitle = screenSize > 800 ? 'Appflowy Marketplace' : '';

    final List<Widget> actions = [
      Padding(
        padding: const EdgeInsets.all(UiUtils.sizeS),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState state) {
            if (state is Loading) {
              return TextButton(
                onPressed: () => {},
                child: const CircularProgressIndicator(),
              );
            } else if (state is UnAuthenticated ||
                state is RegistrationSuccess) {
              return TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signin'),
                child: const Text('Signin'),
              );
            } else if (state is AuthenticateSuccess) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: UiUtils.sizeL,
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
      )
    ];

    final AppBar appBar = AppBar(
      automaticallyImplyLeading: false,
      leading: null,
      centerTitle: true,
      toolbarHeight: 80,
      title: Row(
        children: [
          HoverOpacityWidget(
            onTap: () =>
                curRoute != '/' ? Navigator.of(context).pushNamed('/') : null,
            child: Row(
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
              ],
            ),
          ),
          const Spacer(),
          curRoute == '/' ? const SearchInput() : const SizedBox(),
          const Spacer(),
        ],
      ),
      actions: actions,
    );

    return SelectionArea(
      child: Scaffold(
        key: widget.scaffoldKey,
        appBar: appBar,
        body: widget.body,
        floatingActionButton: widget.floatingActionButton,
        endDrawer: Drawer(child: widget.drawerContent),
      ),
    );
  }
}
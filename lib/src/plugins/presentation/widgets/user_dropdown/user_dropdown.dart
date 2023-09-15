import 'package:appflowy_theme_marketplace/src/authentication/application/auth_bloc/auth_bloc.dart';
import 'package:appflowy_theme_marketplace/src/plugins/presentation/widgets/user_dropdown/popup_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/ui_utils.dart';
import '../../../domain/models/user.dart';

class UserDropDown extends StatefulWidget {
  const UserDropDown({super.key, required this.user});

  final User user;

  @override
  State<UserDropDown> createState() => _UserDropDownState();
}

class _UserDropDownState extends State<UserDropDown> {
  String? username;

  @override
  void initState() {
    super.initState();
  }

  String truncateText(String value, int maxLength) {
    if (value.length > maxLength) {
      value = '${value.substring(0, maxLength - 3)}...';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final String userEmail = widget.user.email ?? UiUtils.defaultEmail;
    final username = widget.user.name ?? UiUtils.defaultUsername(userEmail);
    final maxLength = widget.user.uid.length;
    final userInfo = SelectionArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: UiUtils.sizeM),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              truncateText(userEmail, maxLength),
              style: const TextStyle(
                color: Colors.white,
                fontSize: UiUtils.sizeM,
              ),
            ),
            const SizedBox(height: UiUtils.sizeXS),
            Text(
              truncateText(username, maxLength),
              style: const TextStyle(
                color: Colors.white,
                fontSize: UiUtils.sizeM,
              ),
            ),
            const SizedBox(height: UiUtils.sizeXS),
            Text(
              widget.user.uid,
              style: const TextStyle(
                color: Colors.white,
                fontSize: UiUtils.sizeM,
              ),
            ),
            Divider(
              height: UiUtils.sizeXXL,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );

    final PopupMenuItem<String> userHeader = PopupMenuItem(
      value: 'user',
      enabled: false,
      child: userInfo,
    );

    List<PopupMenuItem<String>> options = [
      userHeader,
      const PopupMenuItem(
        value: '/user/plugins',
        child: PopupText(text: 'Manage Plugin'),
      ),
      const PopupMenuItem(
        value: '/ratings',
        child: PopupText(text: 'Ratings'),
      ),
      const PopupMenuItem(
        value: '/orders',
        child: PopupText(text: 'Orders'),
      ),
      const PopupMenuItem(
        value: 'signout',
        child: PopupText(text: 'Signout'),
      ),
    ];
    return PopupMenuButton(
      itemBuilder: (context) => options,
      tooltip: 'Show User Menu',
      splashRadius: UiUtils.sizeXL,
      padding: const EdgeInsets.all(0),
      onSelected: (value) {
        final curRoute = ModalRoute.of(context)?.settings.name;
        if (value != curRoute) {
          switch (value) {
            case '/ratings':
              Navigator.pushNamed(context, value);
              break;
            case '/orders':
              Navigator.pushNamed(context, value);
              break;
            case '/user/plugins':
              Navigator.pushNamed(context, value);
              break;
            case 'signout':
              BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
              Navigator.pushNamed(context, '/');
              break;
          }
        }
      },
      icon: Icon(
        Icons.account_circle_sharp,
        color: Colors.grey[300],
      ),
    );
  }
}

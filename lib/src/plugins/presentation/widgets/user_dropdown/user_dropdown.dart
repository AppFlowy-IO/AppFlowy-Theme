import 'package:appflowy_theme_marketplace/src/authentication/application/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../user/application/bloc/orders_bloc/orders_bloc.dart';
import '../../../../user/application/bloc/user_bloc/user_bloc.dart';
import '../../../domain/models/user.dart';

class UserDropDown extends StatefulWidget {
  const UserDropDown({super.key, required this.user});

  final User user;

  @override
  State<UserDropDown> createState() => _UserDropDownState();
}

class _UserDropDownState extends State<UserDropDown> {
  String? _selectedOption;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String userEmail = widget.user.email ?? 'Guest';
    final username = userEmail.split('@')[0];
    List<DropdownMenuItem<String>> options = [
      DropdownMenuItem(
        value: 'User',
        child: Text(
          username,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      const DropdownMenuItem(
        value: 'Ratings',
        child: Text(
          'Ratings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const DropdownMenuItem(
        value: 'Orders',
        child: Text(
          'Orders',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const DropdownMenuItem(
        value: 'Profile',
        child: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const DropdownMenuItem(
        value: 'Signout',
        child: Text(
          'Signout',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ];
    _selectedOption = options[0].value;

    final userStatus = context.read<AuthBloc>().state;
    return DropdownButton<String>(
      value: 'User',
      elevation: 16,
      style: const TextStyle(color:Colors.black54),
      icon: null,
      
      underline: Container(
        height: 1,
        color: Colors.transparent,
      ),
      onChanged: (String? value) {
        switch (value) {
          case 'Ratings':
            {
            }
            break;
          case 'Orders':
            {
              Navigator.pushNamed(context, '/orders');
            }
            break;
          case 'Profile':
            {
              Navigator.pushNamed(context, '/user');
            }
            break;
          case 'Signout':
            {
              BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
            }
            break;
        }
        _selectedOption = value;
      },
      items: options,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../application/bloc/user_bloc/user_bloc.dart';

class UserBody extends StatefulWidget {
  const UserBody({super.key});

  @override
  State<UserBody> createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  @override
  void initState() {
    final userStatus = context.read<AuthBloc>().state;
    if(userStatus is AuthenticateSuccess)
      context.read<UserBloc>().add(UserDataRequested(userStatus.user!.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userStatus = context.read<AuthBloc>().state;

    return SingleChildScrollView(
      child: Center(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (BuildContext context, UserState state) {
            if(state is UserInitial && userStatus is AuthenticateSuccess)
              context.read<UserBloc>().add(UserDataRequested(userStatus.user!.uid));
          },
          builder: (BuildContext context, UserState state) {
            if(state is UserInitial && userStatus is AuthenticateSuccess){
              return ElevatedButton(
                onPressed: () => context.read<UserBloc>().add(UserDataRequested(userStatus.user!.uid)),
                child: const Text('get data'),
              );
            }
            if (state is UserLoading) {
              return const CircularProgressIndicator();
            }
            else if (state is UserLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text(state.user.uid),
                    Text(state.user.email),
                    Text(state.user.name),
                    Text(state.user.stripeId ?? ''),
                  ]
                ),
              );
            }
            else {
              return Text(state is UserLoadFailed ? state.message : state.toString());
            }
          },
        ),
      ),
    );
  }
}

import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/auth_bloc/auth_bloc.dart';

class PasswordRecoveryForm extends StatefulWidget {
  const PasswordRecoveryForm({super.key});

  @override
  State<PasswordRecoveryForm> createState() => PasswordRecoveryFormState();
}

class PasswordRecoveryFormState extends State<PasswordRecoveryForm> {
  String emailAddress = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is SendingEmail)
          return const Center(child: CircularProgressIndicator());
        return SizedBox(
          width: 300,
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14),
                ),
                onChanged: (value) => setState(() {
                  emailAddress = value;
                }),
              ),
              const SizedBox(height: UiUtils.sizeL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.read<AuthBloc>().add(
                    RecoverEmailRequested(
                      email: emailAddress,
                    ),
                  ),
                  child: const Text('Send recovery Email'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

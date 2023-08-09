import 'package:appflowy_theme_marketplace/src/user/application/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../../widgets/ui_utils.dart';

class RegisterBody extends StatelessWidget {
  RegisterBody({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController = TextEditingController();

  InputDecoration decoration({required String labelText}) {
    return InputDecoration(labelText: labelText);
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Register',
              style: TextStyle(
                fontSize: HeaderSize.h6,
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: decoration(labelText: 'name'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your name';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: decoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!(value.contains('@') && value.contains('.'))) {
                  return 'Invalid email format';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: decoration(labelText: 'Enter Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _verifyPasswordController,
              decoration: decoration(labelText: 'Renter your Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please re-enter a password';
                } else if (value != _passwordController.text) {
                  return 'The password does not match';
                }
                return null;
              },
              onFieldSubmitted: (_) => _submitForm(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      context.read<AuthBloc>().add(RegisterUserRequested(email, password, name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
            width: 300,
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                // if(state is RegistrationSuccess){
                //   context.read<AuthBloc>().add(SignInRequested(_emailController.text, _passwordController.text));
                // }
                // else if(state is AuthenticateSuccess)
                //   Navigator.of(context).pop();
              },
              builder: (context, state) {
                // if(true){
                if (state is RegistrationSuccess || state is VerificationEmailSent || state is SendingEmail) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 100),
                      const Icon(Icons.check, size: IconSize.xxl),
                      const SizedBox(height: UiUtils.sizeM),
                      const Text(
                        'Thank you for registering, please check your email to verify the account',
                        style: TextStyle(fontSize: HeaderSize.h3),
                      ),
                      const SizedBox(height: UiUtils.sizeM),
                      (state is SendingEmail)
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () => BlocProvider.of<AuthBloc>(context).add(VerifyEmailRequested()),
                            child:const Text('Resend the email verification'),
                          ),
                      const SizedBox(height: UiUtils.sizeM),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(SignInRequested(_emailController.text, _passwordController.text));
                          Navigator.of(context).pop();
                        },
                        child: const Text('Go to dashboard'),
                      ),
                      const SizedBox(height: UiUtils.sizeM),
                      ElevatedButton(
                        onPressed: () async => BlocProvider.of<UserBloc>(context).add(CreateAccount()),
                        child: const Text('Become A seller'),
                      ),
                      const SizedBox(height: UiUtils.sizeM),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildForm(context),
                      if (state is RegistrationFailed)
                        Text(
                          textAlign: TextAlign.center,
                          state.message,
                          style: const TextStyle(
                            color: UiUtils.error,
                          ),
                        ),
                      const SizedBox(height: UiUtils.sizeL),
                      if (state is Loading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      const SizedBox(height: UiUtils.sizeL),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: UiUtils.sizeM),
                        child: ElevatedButton(
                          onPressed: () => _submitForm(context),
                          child: Text(state is RegistrationFailed ? 'Try again' : 'Register'),
                        ),
                      ),
                    ],
                  );
                }
              },
            )),
      ),
    );
  }
}

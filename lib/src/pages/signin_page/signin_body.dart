
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../blocs/auth_bloc/auth_state.dart';
import '../../utils/ui_utils.dart';

class SigninBody extends StatefulWidget {
  const SigninBody({super.key});

  @override
  State<SigninBody> createState() => _SigninBodyState();
}

class _SigninBodyState extends State<SigninBody> {
  late String _emailAddress;
  late String _password;
  bool hidePassword = true;
  
  @override
  void initState() {
    super.initState();
    _emailAddress = '';
    _password = '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14),
                ),
                onChanged: (value) => setState(() {
                  _emailAddress = value;
                }),
              ),
              const SizedBox(height: 20),
              TextField(
                textInputAction: TextInputAction.done,
                obscureText: hidePassword,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(fontSize: 14),
                  suffixIcon: GestureDetector(
                    onTap: () => {
                      setState(() {
                        hidePassword = !hidePassword;
                      })
                    },
                    child: hidePassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                  ),
                ),
                onChanged: (value) => setState(() {
                  _password = value;
                }),
                onSubmitted: (_) => context.read<AuthBloc>().add(SignInRequested(_emailAddress, _password)),
              ),
              const SizedBox(height: 10),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthenticateSuccess)
                    Navigator.pop(context);
                },
                builder: (context, state) {
                  if(state is Loading)
                    return const CircularProgressIndicator();
                  return Column(
                    children: [
                      if(state is AuthenticateFailed)
                        Text(state.message,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => context.read<AuthBloc>().add(SignInRequested(_emailAddress, _password)),
                          child: const Text('Sign in')
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: UiUtils.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text('Forgot password?'),
                ], 
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      height: 50,
                      color: Colors.grey[400],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Or continue with',
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      height: 50,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.google),
                onPressed: () => context.read<AuthBloc>().add(GoogleSignInRequested()),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
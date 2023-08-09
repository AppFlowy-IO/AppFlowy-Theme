part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class RegisterUserRequested extends AuthEvent {
  RegisterUserRequested(this.email, this.password, [this.name]);
  
  final String? name;
  final String email;
  final String password;
}

class SignInRequested extends AuthEvent {
  SignInRequested(this.email, this.password);
  
  final String email;
  final String password;
}

class GoogleSignInRequested extends AuthEvent {
  GoogleSignInRequested();
}

class SignOutRequested extends AuthEvent {
  SignOutRequested();
}

class VerifyEmailRequested extends AuthEvent {
  VerifyEmailRequested();
}
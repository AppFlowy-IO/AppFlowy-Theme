import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class Loading extends AuthState {
  const Loading();

  @override
  List<Object?> get props => [];
}

class AuthenticateSuccess extends AuthState {
  const AuthenticateSuccess({required userData}) : user = userData;

  final User? user;

  @override
  List<Object?> get props => [user];
}

class RegistrationSuccess extends AuthState {
  const RegistrationSuccess({required userData}) : user = userData;
 
  final User? user;
  
  @override
  List<Object> get props => [];
}

class RegistrationFailed extends AuthState {
  RegistrationFailed({message})
      : message = message.replaceAll('Exception: ', '');

  final String message;

  @override
  List<Object?> get props => [];
  
}

class AuthenticateFailed extends AuthState {
  AuthenticateFailed({message})
      : message = message.replaceAll('Exception: ', '');

  final String message;

  @override
  List<Object?> get props => [message];
  
}

class UnAuthenticated extends AuthState{
  const UnAuthenticated();
 
  @override
  List<Object> get props => [];
}
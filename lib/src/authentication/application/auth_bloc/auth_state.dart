part of 'auth_bloc.dart';

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
  const RegistrationFailed({required this.message});

  final String message;

  @override
  List<Object?> get props => [];

}

class AuthenticateFailed extends AuthState {
  const AuthenticateFailed({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];

}

class UnAuthenticated extends AuthState{
  const UnAuthenticated();

  @override
  List<Object> get props => [];
}

class SendingEmail extends AuthState{
  const SendingEmail();

  @override
  List<Object> get props => [];
}

class EmailSent extends AuthState{
  const EmailSent();

  @override
  List<Object> get props => [];
}

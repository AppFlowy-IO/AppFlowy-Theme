part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class CreateAccount extends UserEvent {
  @override
  List<Object> get props => [];
}

class CreatingAccount extends UserEvent {
  @override
  List<Object> get props => [];
}

class CreateSuccess extends UserEvent {
  @override
  List<Object> get props => [];
}

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserDataRequested extends UserEvent {
  const UserDataRequested(this.uid);

  final String uid;

  @override
  List<Object> get props => [];
}
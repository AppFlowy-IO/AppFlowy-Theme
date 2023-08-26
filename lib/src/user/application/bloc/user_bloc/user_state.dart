part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  const UserLoaded(this.user);
  
  final User user;

  @override
  List<Object> get props => [];
}

class UserLoadFailed extends UserState {
  UserLoadFailed({message})
    : message = message.replaceAll('Exception: ', '');

  final String message;
  @override
  List<Object> get props => [];
}


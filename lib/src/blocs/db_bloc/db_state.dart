import 'package:equatable/equatable.dart';

class DbState extends Equatable {
  DbState();
  
  @override
  List<Object?> get props => [];
}

class DbDefault extends DbState{
  @override
  List<Object?> get props => [];
}

class DbLoading extends DbState{
  @override
  List<Object?> get props => [];
}

class DbUpdated extends DbState {
  @override
  List<Object?> get props => [];
}

class DbReloading extends DbState {
  @override
  List<Object?> get props => [];
}

class DbFailed extends DbState {
  DbFailed({required message})
      : message = message.replaceAll('Exception: ', '');

  final String message;

  @override
  List<Object?> get props => [];
}
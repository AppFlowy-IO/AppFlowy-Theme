part of 'plugin_bloc.dart';

abstract class PluginState extends Equatable {
  const PluginState();

  @override
  List<Object?> get props => [];
}

class PluginDefault extends PluginState {
  @override
  List<Object?> get props => [];
}

class PluginLoading extends PluginState {
  @override
  List<Object?> get props => [];
}

class PluginUpdated extends PluginState {
  @override
  List<Object?> get props => [];
}

class PluginReloading extends PluginState {
  @override
  List<Object?> get props => [];
}

class PluginFailed extends PluginState {
  PluginFailed({required message}) : message = message.replaceAll('Exception: ', '');

  final String message;

  @override
  List<Object?> get props => [];
}

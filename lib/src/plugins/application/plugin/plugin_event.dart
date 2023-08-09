part of 'plugin_bloc.dart';

abstract class PluginEvent extends Equatable {
  const PluginEvent();

  @override
  List<Object> get props => [];
}

class UploadDataRequested extends PluginEvent {
  const UploadDataRequested(this.user, this.plugin, this.price);

  final User user;
  final PickedFile plugin;
  final double price;

  @override
  List<Object> get props => [];
}

class AddRatingDataRequested extends PluginEvent {
  const AddRatingDataRequested(this.pluginId, this.rating);

  final String pluginId;
  final Rating rating;

  @override
  List<Object> get props => [];
}

class ResetStateRequested extends PluginEvent {
  @override
  List<Object> get props => [];
}

class PluginReloadRequested extends PluginEvent {
  @override
  List<Object> get props => [];
}

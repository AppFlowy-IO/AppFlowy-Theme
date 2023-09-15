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
  const AddRatingDataRequested(this.rating);

  final Rating rating;

  @override
  List<Object> get props => [];
}

class UpdatePluginRequested extends PluginEvent {
  const UpdatePluginRequested({required this.user, required this.plugin, required this.price});

  final User user;
  final PickedFile plugin;
  final double price;

  @override
  List<Object> get props => [];
}

class DeletePluginRequested extends PluginEvent {
  const DeletePluginRequested(this.plugin);

  final Plugin plugin;

  @override
  List<Object> get props => [];
}

class IncrementDownloadCountRequested extends PluginEvent {
  const IncrementDownloadCountRequested(this.plugin);

  final Plugin plugin;

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

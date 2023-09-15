part of 'plugin_search_bloc.dart';

abstract class PluginSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PluginSearchRequested extends PluginSearchEvent {
  PluginSearchRequested(this.searchTerm);

  final String searchTerm;
}

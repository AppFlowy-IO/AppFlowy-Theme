part of 'plugin_search_bloc.dart';

abstract class PluginSearchState extends Equatable {
  PluginSearchState({List<Plugin>? filesList}) : filesList = filesList ?? [];

  final List<Plugin> filesList;
}

class EmptySearch extends PluginSearchState {
  EmptySearch({super.filesList});

  @override
  List<Object?> get props => [];
}

class SearchLoading extends PluginSearchState {
  SearchLoading({super.filesList});

  @override
  List<Object?> get props => [];
}

class SearchSuccess extends PluginSearchState {
  SearchSuccess({required List<Plugin> filesList}) : super(filesList: filesList);

  @override
  List<Object?> get props => [];
}

class SearchFailed extends PluginSearchState {
  SearchFailed({super.filesList});

  @override
  List<Object?> get props => [];
}

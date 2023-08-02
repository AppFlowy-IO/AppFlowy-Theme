import 'package:equatable/equatable.dart';

abstract class SearchFilesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchFilesRequested extends SearchFilesEvent {
  SearchFilesRequested(this.searchTerm);

  final String searchTerm;
}

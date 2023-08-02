import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class SearchFilesState extends Equatable {
  SearchFilesState({List<QueryDocumentSnapshot<Object?>>? filesList}) : filesList = filesList ?? [];

  final List<QueryDocumentSnapshot<Object?>> filesList;
}

class EmptySearch extends SearchFilesState {
  EmptySearch({super.filesList});
  
  @override
  List<Object?> get props => [];
}

class SearchLoading extends SearchFilesState {
  SearchLoading({super.filesList});
  
  @override
  List<Object?> get props => [];
}

class SearchSuccess extends SearchFilesState {
  SearchSuccess({required List<QueryDocumentSnapshot<Object?>> filesList}) : super(filesList: filesList);

  @override
  List<Object?> get props => [];
}

class SearchFailed extends SearchFilesState {
  SearchFailed({super.filesList});

  @override
  List<Object?> get props => [];
}
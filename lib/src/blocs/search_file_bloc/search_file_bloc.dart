import 'package:appflowy_theme_marketplace/src/utils/firestore_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_file_event.dart';
import 'search_file_state.dart';

class SearchFilesBloc extends Bloc<SearchFilesEvent, SearchFilesState>{
  SearchFilesBloc() : super(EmptySearch()) {
    on<SearchFilesRequested>((SearchFilesRequested event, Emitter<SearchFilesState> emit) async {
        emit(SearchLoading());
        try {
          if(event.searchTerm == '')
            emit(EmptySearch());
          else {
            final filesList = await FireStoreUtils.listFiles(event.searchTerm);
            emit(SearchSuccess(filesList: filesList));
          }
        } on Exception catch (e) {
          emit(SearchFailed());
        }
      },
    );
  }

}
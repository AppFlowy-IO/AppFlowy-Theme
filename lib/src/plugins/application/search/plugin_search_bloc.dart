import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'plugin_search_event.dart';
part 'plugin_search_state.dart';

class PluginSearchBloc extends Bloc<PluginSearchEvent, PluginSearchState> {
  final PluginRepository pluginRepository;
  PluginSearchBloc({
    required this.pluginRepository,
  }) : super(EmptySearch()) {
    on<PluginSearchRequested>(
      (PluginSearchRequested event, Emitter<PluginSearchState> emit) async {
        emit(SearchLoading());
        try {
          if (event.searchTerm == '')
            emit(EmptySearch());
          else {
            final filesList = await pluginRepository.list(event.searchTerm);
            emit(SearchSuccess(filesList: filesList));
          }
        } on Exception catch (e) {
          emit(SearchFailed());
        }
      },
    );
  }
}

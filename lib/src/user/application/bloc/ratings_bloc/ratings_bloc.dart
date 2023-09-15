import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/ratings_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/ui_utils.dart';
import '../../../domain/models/rating.dart';
import '../../factories/rating_factory.dart';

part 'ratings_event.dart';
part 'ratings_state.dart';

class RatingsBloc extends Bloc<RatingsEvent, RatingsState> {
  final RatingsRepository ratingsRepository;
  RatingsBloc({
    required this.ratingsRepository,
  }) : super(RatingsInitial()) {
    on<GetAllRatingsRequested>((event, emit) async {
      emit(RatingsLoading());
      await UiUtils.delayLoading();
      try {
        List list = await ratingsRepository.getAll(event.uid);
        List<Rating> ratings = [];
        ratings = list.map((rating) {
          return RatingFactory.fromPlugin(rating);
        }).toList();
        emit(RatingsLoaded(ratings));
      } on Exception catch (e) {
        debugPrint('failed $e');
        emit(RatingsLoadFailed(message: e.toString()));
      }
    });
  }
}


import 'package:appflowy_theme_marketplace/src/utils/firestore_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/storage_utils.dart';
import 'db_event.dart';
import 'db_state.dart';

class DbBloc extends Bloc<DbEvent, DbState> {
  DbBloc() : super(DbDefault()){
    on<UploadDataRequested>((UploadDataRequested event, Emitter<DbState> emit) async {
      emit(DbLoading());
      try {
        await StorageUtils.uploadFile(event.uploadFile.bytes, event.uploadFile.name, event.user, event.price);
        emit(DbUpdated());
      } on Exception catch(e) {
        emit(DbFailed(message: e.toString()));
      }
    });
    on<AddRatingDataRequested>((AddRatingDataRequested event, Emitter<DbState> emit) async {
      emit(DbLoading());
      try {
        await FireStoreUtils.addRating(event.ratingDocId, event.rating);
        emit(DbUpdated());
      } on Exception catch(e) {
        emit(DbFailed(message: e.toString()));
      }
    });
    on<ResetStateRequested>(
      (ResetStateRequested event, Emitter<DbState> emit) async {
        emit(DbLoading());
        try {
          emit(DbDefault());
        } on Exception catch (e) {
          emit(DbFailed(message: e.toString()));
        }
      },
    );
    on<DbReloadRequested>(
      (DbReloadRequested event, Emitter<DbState> emit) async {
        emit(DbReloading());
        await Future.delayed(const Duration(milliseconds: 100), () {});
        emit(DbDefault());
      }
    );
  }
  
}
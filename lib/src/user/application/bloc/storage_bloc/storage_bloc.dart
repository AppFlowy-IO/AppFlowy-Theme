
import 'package:appflowy_theme_marketplace/src/user/domain/models/plugin_file_object.dart';
import 'package:appflowy_theme_marketplace/src/user/domain/repositories/storage_repository.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/picked_file.dart';
import '../../../domain/models/plugin.dart';
import '../../../domain/models/user.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final FileStorageRepository storageRepository;
  StorageBloc({
    required this.storageRepository,
  }) : super(StorageDefault()) {
    on<UploadFileRequested>((UploadFileRequested event, Emitter<StorageState> emit) async {
      emit(StorageUploading());
      try {
        final picked = event.plugin;
        final plugin = Plugin.upload(
          pickedFile: picked,
          name: picked.name,
          uploader: event.user,
          price: event.price,
        );
        await storageRepository.add(plugin);
        emit(StorageUploadSuccess());
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(StorageFailed(message: e.toString()));
      }
    });
    on<GetUploadedFilesRequested>((GetUploadedFilesRequested event, Emitter<StorageState> emit) async {
      emit(StorageSearching());
      try {
        List<PluginFileObject> files = await storageRepository.get(event.searchTerm, event.uid, event.bucket);
        emit(StorageSearchSuccess(files: files));
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(StorageFailed(message: e.toString()));
      }
    });
    on<DeleteFileRequested>((DeleteFileRequested event, Emitter<StorageState> emit) async {
      emit(StorageDeletingFile());
      await UiUtils.delayLoading();
      try {
        List<PluginFileObject> files = await storageRepository.delete(event.fileName, event.bucket, event.user.uid);
        emit(StorageDeleteSuccess(files: files));
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(StorageFailed(message: e.toString()));
      }
    });
    on<StorageReloadRequested>((StorageReloadRequested event, Emitter<StorageState> emit) async {
      emit(StorageUploading());
      await Future.delayed(const Duration(milliseconds: 100), () {});
      emit(StorageDefault());
    });
  }
  
}
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/rating.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/ratings_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/models/pickedFile.dart';
import '../../domain/models/user.dart';

part 'plugin_event.dart';
part 'plugin_state.dart';

class PluginBloc extends Bloc<PluginEvent, PluginState> {
  final PluginRepository pluginRepository;
  final RatingsRepository ratingsRepository;
  PluginBloc({
    required this.pluginRepository,
    required this.ratingsRepository,
  }) : super(PluginDefault()) {
    on<UploadDataRequested>((UploadDataRequested event, Emitter<PluginState> emit) async {
      emit(PluginLoading());
      try {
        final picked = event.plugin;
        final plugin = Plugin.upload(
          pickedFile: picked,
          name: picked.name,
          uploader: event.user,
          price: event.price,
        );
        await pluginRepository.add(plugin);
        emit(PluginUpdated());
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(PluginFailed(message: e.toString()));
      }
    });
    on<AddRatingDataRequested>((AddRatingDataRequested event, Emitter<PluginState> emit) async {
      emit(PluginLoading());
      try {
        await ratingsRepository.add(event.pluginId, event.rating);
        emit(PluginUpdated());
      } on Exception catch (e) {
        debugPrint(e.toString());
        emit(PluginFailed(message: e.toString()));
      }
    });
    on<IncrementDownloadCountRequested>((IncrementDownloadCountRequested event, Emitter<PluginState> emit) async {
      try {
        await pluginRepository.update(event.plugin);
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    });
    on<ResetStateRequested>(
      (ResetStateRequested event, Emitter<PluginState> emit) async {
        emit(PluginLoading());
        try {
          emit(PluginDefault());
        } on Exception catch (e) {
          emit(PluginFailed(message: e.toString()));
        }
      },
    );
    on<PluginReloadRequested>((PluginReloadRequested event, Emitter<PluginState> emit) async {
      emit(PluginReloading());
      await Future.delayed(const Duration(milliseconds: 100), () {});
      emit(PluginDefault());
    });
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:appflowy_theme_marketplace/src/plugins/data/supabase_repository/helpers/supabase_db_utils.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';
import 'package:archive/archive.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'helpers/supabase_storage_utils.dart';

class SupabasePluginRepository implements PluginRepository {
  final sp = supabase.Supabase.instance.client;

  @override
  Future<void> add(Plugin plugin) async {
    if(plugin.pickedFile == null)
      throw Exception('no file is picked');
    await SupabaseStorageUtils.uploadFile(plugin);
  }

  @override
  Future<List<Plugin>> byDate([bool ascending = false]) async {
    List<Plugin> plugins = await SupabaseDbUtils.listFilesByDate(ascending);
    return plugins;
  }

  @override
  Future<List<Plugin>> byDownloadCount([bool ascending = false]) async {
    List<Plugin> plugins = await SupabaseDbUtils.listFilesByDownloadCount(ascending);
    return plugins;
  }

  @override
  Future<List<Plugin>> byName([bool ascending = false]) async {
    List<Plugin> plugins = await SupabaseDbUtils.listFilesByName();
    return plugins;
  }

  @override
  Future<List<Plugin>> byRatings([bool ascending = false]) async {
    List<Plugin> plugins = await SupabaseDbUtils.listFilesByRatings(ascending);
    return plugins;
  }

  @override
  Future<void> delete(Plugin plugin) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Plugin> get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<Plugin>> list([String? searchTerm = '']) async {
    List<Plugin> plugins = await SupabaseDbUtils.listFiles(searchTerm);
    return plugins;
  }

  @override
  Future<void> update(Plugin plugin) async {
    await sp.rpc(
      'increment_plugin_download_count',
      params: {
        'product_id': plugin.pluginId,
      },
    );
  }
}

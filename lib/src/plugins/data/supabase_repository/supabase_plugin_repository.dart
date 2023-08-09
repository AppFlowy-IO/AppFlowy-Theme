import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/plugins/domain/repositories/plugin_repository.dart';

class SupabasePluginRepository implements PluginRepository {
  @override
  Future<void> add(Plugin plugin) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<List<Plugin>> byDate([bool descending = true]) {
    // TODO: implement byDate
    throw UnimplementedError();
  }

  @override
  Future<List<Plugin>> byDownloadCount([bool descending = true]) {
    // TODO: implement byDownloadCount
    throw UnimplementedError();
  }

  @override
  Future<List<Plugin>> byName([bool descending = true]) {
    // TODO: implement byName
    throw UnimplementedError();
  }

  @override
  Future<List<Plugin>> byRatings([bool descending = true]) {
    // TODO: implement byRatings
    throw UnimplementedError();
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
  Future<List<Plugin>> list([String? searchTerm = '']) {
    // TODO: implement plugins
    throw UnimplementedError();
  }

  @override
  Future<void> update(Plugin plugin) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

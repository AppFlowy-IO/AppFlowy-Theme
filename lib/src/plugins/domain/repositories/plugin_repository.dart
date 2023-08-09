import '../models/plugin.dart';

abstract class PluginRepository {
  Future<List<Plugin>> list([String? searchTerm = '']);
  Future<List<Plugin>> byName([bool descending = true]);
  Future<List<Plugin>> byDownloadCount([bool descending = true]);
  Future<List<Plugin>> byRatings([bool descending = true]);
  Future<List<Plugin>> byDate([bool descending = true]);
  Future<Plugin> get(String id);
  Future<void> add(Plugin plugin);
  Future<void> update(Plugin plugin);
  Future<void> delete(Plugin plugin);
}

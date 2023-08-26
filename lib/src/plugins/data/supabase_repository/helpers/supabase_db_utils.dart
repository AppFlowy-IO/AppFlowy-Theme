import '../../../domain/models/plugin.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseDbUtils {
  static final sp = supabase.Supabase.instance.client;

  static List<Plugin> toPlugin(List<dynamic> objectEventsList) {
    final pluginsList = objectEventsList.map((fileMap) {
      final Plugin zipFile = Plugin.fromJson(fileMap);
      return zipFile;
    }).toList();
    return pluginsList;
  }

  static Future<List<Plugin>> listFiles([String? searchTerm = '']) async {
    late final List<Plugin> result;
    final data = await sp.from('files').select('*');
    result = toPlugin(data);
    if(searchTerm == null || searchTerm == '')
      return result;
    else  
      return result.where((item) => item.name.toLowerCase().contains(searchTerm)).toList();
  }
  static Future<List<Plugin>> listFilesByName([bool ascending = true]) async {
    final data = await sp.from('files').select('*').order('name', ascending: ascending);
    final List<Plugin> result = toPlugin(data);
    return result;
  }
  static Future<List<Plugin>> listFilesByDownloadCount([bool ascending = true]) async {
    final data = await sp.from('files').select('*').order('download_count', ascending: ascending);
    final List<Plugin> result = toPlugin(data);
    return result;
  }
  static Future<List<Plugin>> listFilesByRatings([bool ascending = true]) async {
    final data = await sp.from('files').select('*').order('rating', ascending: ascending);
    final List<Plugin> result = toPlugin(data);
    return result;
  }
  static Future<List<Plugin>> listFilesByDate([bool ascending = true]) async {
    final data = await sp.from('files').select('*').order('created_at', ascending: ascending);
    final List<Plugin> result = toPlugin(data);
    return result;
  }
}
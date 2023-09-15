import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([SupabaseClient])
@GenerateMocks([SupabaseStorageClient])
@GenerateMocks([http.Client])
Future<void> main() async {

}
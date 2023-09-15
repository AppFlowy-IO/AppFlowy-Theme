import 'package:appflowy_theme_marketplace/src/authentication/data/repositories/supabase_authentication_repository.dart';
import 'package:appflowy_theme_marketplace/src/authentication/domain/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:http/http.dart' as http;

import 'supabase_auth_repo_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<supabase.GoTrueClient>(),
  MockSpec<supabase.AuthResponse>(),
  MockSpec<User>(),
  MockSpec<http.Client>(),
])
Future<void> main() async {
  late MockGoTrueClient auth;
  late MockAuthResponse authResponse;
  late SupabaseAuthenticationRepository authRepo;
  late MockClient client;
  setUp(() {
    auth = MockGoTrueClient();
    authResponse = MockAuthResponse();
    client = MockClient();
    authRepo = SupabaseAuthenticationRepository(auth: auth, client: client);
  });

  group('auth register test', () {
    test('test register success', () async {
      when(auth.signUp(
        email: anyNamed('email'),
        password: anyNamed('password'),
        emailRedirectTo: anyNamed('emailRedirectTo'),
        phone: anyNamed('phone'),
        data: anyNamed('data'),
        captchaToken: anyNamed('captchaToken'),
      ))
        .thenAnswer((realInvocation) => Future(() => authResponse));
      expect(auth.signUp(email: 'someemail@gmail.com', password: '123456'), completion(authResponse));
      
      supabase.AuthResponse response = supabase.AuthResponse(
        user: const supabase.User(
          id: '',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: '',
        ),
      );
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('', 200));
      when(authResponse.session).thenReturn(response.session);
      when(authResponse.user).thenReturn(response.user);
      expect(await authRepo.register(emailAddress: 'someemail@gmail.com', password: '123456', key: ''), isA<User?>());
    });

    test('test register fail', () async {
      when(auth.signUp(
        email: anyNamed('email'),
        password: anyNamed('password'),
        emailRedirectTo: anyNamed('emailRedirectTo'),
        phone: anyNamed('phone'),
        data: anyNamed('data'),
        captchaToken: anyNamed('captchaToken'),
      ))
        .thenAnswer((realInvocation) => Future(() => throw Exception()));
      when(auth.signUp(email: '', password: '123456')).thenAnswer((realInvocation) async {
        throw Exception();
      });
      when(auth.signUp(email: 'test', password: '123456')).thenAnswer((realInvocation) async {
        throw Exception();
      });
      when(auth.signUp(email: 'test@gmail.com', password: '')).thenAnswer((realInvocation) async {
        throw Exception();
      });

      when(authResponse.user).thenReturn(null);
      when(authResponse.session).thenReturn(null);
      expect(authResponse.user, null);
      expect(authResponse.session, null);
      expect(auth.signUp(email: 'someemail@gmail.com', password: '123456'), throwsException);
      expect(auth.signUp(email: '', password: '123456'), throwsException);
      expect(auth.signUp(email: 'test', password: '123456'), throwsException);
      expect(auth.signUp(email: 'test@gmail.com', password: ''), throwsException);
      expect(authRepo.register(emailAddress: 'someemail@gmail.com', password: '123456', key: ''), throwsException);
    });
  });

  group('auth signin test', () {
    test('test signin success', () {
      when(auth.signInWithPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
        phone: anyNamed('phone'),
        captchaToken: anyNamed('captchaToken'),
      ))
        .thenAnswer((realInvocation) => Future(() => authResponse));
      expect(auth.signInWithPassword(email: 'someemail@gmail.com', password: '123456'), completion(authResponse));
      // expect(auth.signInWithPassword(email: 'someemail@gmail.com', password: '123456', data: any), completion(authResponse));
      supabase.AuthResponse response = supabase.AuthResponse(
        user: const supabase.User(
          id: '',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: '',
        ),
      );
      when(authResponse.session).thenReturn(response.session);
      when(authResponse.user).thenReturn(response.user);
      expect(authRepo.signIn(emailAddress: 'someemail@gmail.com', password: '123456'), completion(isA<User?>()));
    });

    test('test signin fail', () {
      when(auth.signInWithPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
        phone: anyNamed('phone'),
        captchaToken: anyNamed('captchaToken'),
      ))
        .thenAnswer((realInvocation) => Future(() => throw Exception()));
      when(auth.signInWithPassword(email: '', password: '123456',)).thenAnswer((realInvocation) async {
        throw Exception();
      });
      when(auth.signInWithPassword(email: 'test', password: '123456')).thenAnswer((realInvocation) async {
        throw Exception();
      });
      when(auth.signInWithPassword(email: 'test@gmail.com', password: '')).thenAnswer((realInvocation) async {
        throw Exception();
      });
      when(auth.signInWithPassword(email: 'test@gmail.com', phone: anyNamed('phone'), password: '123456', captchaToken: anyNamed('captchaToken'),),).thenAnswer((realInvocation) async {
        throw Exception();
      });
      expect(auth.signInWithPassword(email: '', password: '123456'), throwsException);
      expect(auth.signInWithPassword(email: 'test', password: '123456'), throwsException);
      expect(auth.signInWithPassword(email: 'test@gmail.com', password: ''), throwsException);
      when(authResponse.session).thenReturn(null);
      when(authResponse.user).thenReturn(null);
      expect(authRepo.signIn(emailAddress: 'someemail@gmail.com', password: '123456'), throwsException);
    });
  });

  group('auth signout test', () {
    test('signout success', () {
      when(auth.signOut(
        scope: anyNamed('scope')
      ))
        .thenAnswer((_) async => null);
      expect(auth.signOut(), isA<Future<void>>());
      expect(authRepo.signOut(), isA<Future<void>>());
    });

    test('signout fail', () {
      when(auth.signOut(
        scope: anyNamed('scope')
      ))
        .thenAnswer((realInvocation) => Future(() => throw Exception()));
      
      expect(auth.signOut(), throwsException);
      expect(authRepo.signOut(), throwsException);
    });
  });

  group('auth googld Signin test', () {
    test('google signin success', () {
      
    });

    test('google signin fail', () {

    });
  });
}
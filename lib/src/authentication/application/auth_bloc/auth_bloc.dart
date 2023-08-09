// import 'package:firebase_auth/firebase_auth.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:appflowy_theme_marketplace/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/user.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository authenticationRepository;

  AuthBloc({
    required this.authenticationRepository,
  }) : super(const UnAuthenticated()) {
    authenticationRepository.authStateChanges().listen((User? user) {
      if (user != null) {
        emit(AuthenticateSuccess(userData: user));
      } else {
        emit(const UnAuthenticated());
      }
    });
    on<RegisterUserRequested>(
      (
        RegisterUserRequested event,
        Emitter<AuthState> emit,
      ) async {
        emit(const Loading());
        await UiUtils.delayLoading();
        try {
          final User? firebaseUser = await authenticationRepository.register(
            emailAddress: event.email,
            password: event.password,
            name: event.name
          );
          if(firebaseUser == null)
            throw Exception('user is null');
          User? user = User(uid: firebaseUser.uid, email: firebaseUser.email); 
          await authenticationRepository.sendEmailVerification();
          emit(RegistrationSuccess(userData: user));
        } on Exception catch (e) {
          emit(RegistrationFailed(message: e.toString()));
        }
      },
    );
    on<SignInRequested>(
      (SignInRequested event, Emitter<AuthState> emit) async {
        emit(const Loading());
        await UiUtils.delayLoading();
        try {
          final firebaseUser = await authenticationRepository.signIn(emailAddress: event.email, password: event.password);
          User? user = User(uid: firebaseUser!.uid, email: firebaseUser.email);
          emit(AuthenticateSuccess(userData: user));
        } on Exception catch (e) {
          emit(AuthenticateFailed(message: e.toString()));
        }
      },
    );
    on<GoogleSignInRequested>(
      (GoogleSignInRequested event, Emitter<AuthState> emit) async {
        emit(const Loading());
        await UiUtils.delayLoading();
        try {
          await authenticationRepository.signInWithGoogle();
        } on Exception catch (e) {
          emit(AuthenticateFailed(message: e.toString()));
        }
      },
    );
    on<SignOutRequested>(
      (SignOutRequested event, Emitter<AuthState> emit) async {
        emit(const Loading());
        await UiUtils.delayLoading();
        try {
          await authenticationRepository.signOut();
          emit(const UnAuthenticated());
        } on Exception catch (e) {
          emit(AuthenticateFailed(message: e.toString()));
        }
      },
    );
    on<VerifyEmailRequested>(
      (VerifyEmailRequested event, Emitter<AuthState> emit) async {
        emit(const SendingEmail());
        await UiUtils.delayLoading();
        try {
          await authenticationRepository.sendEmailVerification();
          emit(const VerificationEmailSent());
        } on Exception catch (e) {
          emit(AuthenticateFailed(message: e.toString()));
        }
      },
    );
  }
}

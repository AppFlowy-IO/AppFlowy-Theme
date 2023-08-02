import 'package:appflowy_theme_marketplace/src/models/uploader.dart';
import 'package:appflowy_theme_marketplace/src/utils/firestore_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/auth.dart';
import '../../utils/ui_utils.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const UnAuthenticated()) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        emit(AuthenticateSuccess(userData: user));
      } else {
        emit(const UnAuthenticated());
      }
    });
    on<RegisterUserRequested>((RegisterUserRequested event, Emitter<AuthState> emit) async {
        emit(const Loading());
        await UiUtils.delayLoading();
        try {
          User? user = await Auth.registerUser(emailAddress: event.email, password: event.password, name: event.name);
          emit(RegistrationSuccess(userData: user));
        } on Exception catch (e) {
          emit(RegistrationFailed(message: e.toString()));
        }
      },
    );
    on<SignInRequested>((SignInRequested event, Emitter<AuthState> emit) async {
        emit(const Loading());
        await UiUtils.delayLoading();
        try {
          // late User? user;
          await Auth.signIn(emailAddress: event.email, password: event.password);
          // emit(AuthenticateSuccess(userData: user));
        } on Exception catch (e) {
          emit(AuthenticateFailed(message: e.toString()));
        }
      },
    );
    on<GoogleSignInRequested>((GoogleSignInRequested event, Emitter<AuthState> emit) async {
        emit(const Loading());
        await UiUtils.delayLoading();
        try {
          await Auth.signInWithGoogle();
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
          await Auth.signOut();
          emit(const UnAuthenticated());
        } on Exception catch (e) {
          emit(AuthenticateFailed(message: e.toString()));
        }
      },
    );
  }
}

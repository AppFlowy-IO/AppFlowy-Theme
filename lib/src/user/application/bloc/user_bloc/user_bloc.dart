import 'package:appflowy_theme_marketplace/src/user/domain/repositories/user_repository.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc({
    required this.userRepository,
  }) : super(UserInitial()) {
    on<UserDataRequested>((event, emit) async {
      emit(UserLoading());
      await UiUtils.delayLoading();
      try {
        User user = await userRepository.get(event.uid);
        emit(UserLoaded(user));
      } on Exception catch (e) {
        emit(UserLoadFailed(message: e));
      }
    });
  }
}

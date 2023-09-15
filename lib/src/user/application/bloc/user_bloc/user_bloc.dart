import 'package:appflowy_theme_marketplace/src/user/domain/repositories/user_repository.dart';
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
    on<GetAndUpdateUserDataRequested>((event, emit) async {
      emit(UserLoading());
      try {
        User user = await userRepository.get(event.uid);
        bool onboardCompleted = user.onboardCompleted;
        String? stripeId = user.stripeId;
        if (stripeId == null || stripeId.isEmpty) {
          stripeId = await userRepository.add(user.email);
        }
          
        if (stripeId == null || stripeId.isEmpty) {
          throw Exception('Could not get stripe id from user');
        }
          
        if (!onboardCompleted) {
          await userRepository.update(stripeId);
        }
          
        user = await userRepository.get(event.uid);
        emit(UserLoaded(user));
      } on Exception catch (e) {
        emit(UserLoadFailed(message: e.toString()));
      }
    });
  }
}

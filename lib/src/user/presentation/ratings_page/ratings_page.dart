import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../../plugins/domain/repositories/ratings_repository.dart';
import '../../../widgets/page_layout.dart';
import '../../../widgets/ui_utils.dart';
import 'ratings_body.dart';

class RatingsPage extends StatelessWidget {
  const RatingsPage({super.key, required this.ratingsRepository});

  final RatingsRepository ratingsRepository;

  @override
  Widget build(BuildContext context) {
    double screenSize = (MediaQuery.of(context).size.width - 64);
    final double cardSize = UiUtils.calculateCardSize(screenSize);
      return PageLayout(
       body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (state is AuthenticateSuccess) {
            return RatingsBody(
              userStatus: state,
              ratingsRepository: ratingsRepository,
            );
          } else {
            return PageLayout(
              body: SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: double.infinity,
                  height: cardSize,
                  padding: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
      ),
    );
    
  }
}

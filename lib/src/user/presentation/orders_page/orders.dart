import 'package:appflowy_theme_marketplace/src/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../../widgets/ui_utils.dart';
import 'orders_body.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    double screenSize = (MediaQuery.of(context).size.width - 64);
    final double cardSize = UiUtils.calculateCardSize(screenSize);
    final AuthState userStatus = context.read<AuthBloc>().state;
    if(userStatus is AuthenticateSuccess)
      return PageLayout(body: OrdersBody(userStatus: userStatus));
    return PageLayout(
        body: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          width: double.infinity,
          height: cardSize,
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
        ),
    ));
  }
}
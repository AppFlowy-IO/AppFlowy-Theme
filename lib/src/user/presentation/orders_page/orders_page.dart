import 'package:appflowy_theme_marketplace/src/user/domain/repositories/orders_repository.dart';
import 'package:appflowy_theme_marketplace/src/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import 'orders_body.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, required this.ordersRepository});

  final OrdersRepository ordersRepository;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (state is! AuthenticateSuccess) {
            return const SizedBox();
          }
          return OrdersBody(
            userStatus: state,
            ordersRepository: ordersRepository,
          );
        },
      ),
    );
  }
}

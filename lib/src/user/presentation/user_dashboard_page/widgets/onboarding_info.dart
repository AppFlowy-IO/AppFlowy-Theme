import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../payment/application/payment_bloc/payment_bloc.dart';

class OnboardInfo extends StatelessWidget {
  const OnboardInfo({super.key, required this.stripeId});
  final String stripeId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('You need to link your Stripe account', style: FontText.font_12),
        const Text('To receive payment on our platform', style: FontText.font_12),
        const Text('Please, finish the onboarding process here', style: FontText.font_12),
        ContentSpacer.verticalSpacer_16,
        BlocBuilder<PaymentBloc, PaymentState>(
          builder: (BuildContext context, PaymentState state) {
            if (state is CreatingOnboardingSession) {
              return const TextButton(
                onPressed: null,
                child: CircularProgressIndicator(),
              );
            }
            return ElevatedButton(
              onPressed: () {
                BlocProvider.of<PaymentBloc>(context).add(CreateOnboardingLinkRequested(stripeId));
              },
              child: const Text('Onboard', style: FontText.font_12),
            );
          },
        ),
        
      ],
    );
  }
}
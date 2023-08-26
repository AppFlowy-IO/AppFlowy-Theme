import 'dart:html' as html;
import 'package:appflowy_theme_marketplace/src/payment/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/payment/domain/repositories/payment_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/ui_utils.dart';
import '../../domain/models/user.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;
  
  PaymentBloc({
    required this.paymentRepository
    }) : super(const CreateCheckoutSession()) {
    on<CheckOutSessionRequested>(
      (
        CheckOutSessionRequested event,
        Emitter<PaymentState> emit,
      ) async {
        emit(const CreatingCheckoutSession());
        await UiUtils.delayLoading();
        try {
          final res = await paymentRepository.createInvoice(event.product, event.customer);
          html.window.location.assign(res['url']);
          emit(const CheckoutSessionCreated());
        } on Exception catch (e) {
          emit(CheckoutFailed(message: e.toString()));
        }
      },
    );
    on<CreateOnboardingLinkRequested>(
      (
        CreateOnboardingLinkRequested event,
        Emitter<PaymentState> emit,
      ) async {
        emit(const CreatingCheckoutSession());
        await UiUtils.delayLoading();
        try {
          final res = await paymentRepository.createAccountLink(event.accountId);
          html.window.location.assign(res['url']);
          emit(const CheckoutSessionCreated());
        } on Exception catch (e) {
          emit(CheckoutFailed(message: e.toString()));
        }
      },
    );
  }
}
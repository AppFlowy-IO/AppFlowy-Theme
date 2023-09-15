part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class CreateCheckoutSession extends PaymentState {
  const CreateCheckoutSession();

  @override
  List<Object?> get props => [];
}

class CreatingCheckoutSession extends PaymentState {
  const CreatingCheckoutSession();

  @override
  List<Object?> get props => [];
}

class CheckoutSessionCreated extends PaymentState {
  const CheckoutSessionCreated();

  @override
  List<Object?> get props => [];
}

class CreatingOnboardingSession extends PaymentState {
  const CreatingOnboardingSession();

  @override
  List<Object?> get props => [];
}
class OnboardingSessionCreated extends PaymentState {
  const OnboardingSessionCreated();

  @override
  List<Object?> get props => [];
}

class CheckoutFailed extends PaymentState {
  const CheckoutFailed({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
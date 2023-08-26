part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CheckOutSessionRequested extends PaymentEvent {
  CheckOutSessionRequested(this.product, this.customer);
  
  final Plugin product;
  final User customer;
}

class CreateOnboardingLinkRequested extends PaymentEvent {
  CreateOnboardingLinkRequested(this.accountId);

  final String accountId;
  
}
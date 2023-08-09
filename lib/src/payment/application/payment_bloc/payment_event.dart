part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CheckOutSessionRequested extends PaymentEvent {
  CheckOutSessionRequested(this.seller, this.product, this.cutPercentage);
  
  final User seller;
  final Plugin product;
  final double cutPercentage;
}
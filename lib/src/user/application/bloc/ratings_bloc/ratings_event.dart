part of 'ratings_bloc.dart';

abstract class RatingsEvent {
  const RatingsEvent();
}

class GetAllRatingsRequested extends RatingsEvent {
  const GetAllRatingsRequested(this.uid);

  final String uid;
}

class FindRatingRequested extends RatingsEvent {
  const FindRatingRequested(this.uid, this.productId);

  final String uid;
  final String productId;
}
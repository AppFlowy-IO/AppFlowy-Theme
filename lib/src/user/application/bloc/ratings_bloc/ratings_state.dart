part of 'ratings_bloc.dart';

abstract class RatingsState{
  const RatingsState();
}

class RatingsInitial extends RatingsState {

}

class RatingsLoading extends RatingsState {

}

class RatingsLoaded extends RatingsState {
  const RatingsLoaded(this.ratings);
  
  final List<Rating> ratings;


}

class RatingsLoadFailed extends RatingsState {
  const RatingsLoadFailed({required this.message});

  final String message;

}


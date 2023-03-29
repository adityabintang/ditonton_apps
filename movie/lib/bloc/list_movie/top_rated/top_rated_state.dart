part of 'top_rated_bloc.dart';

abstract class TopRatedState extends Equatable {
  const TopRatedState();

  @override
  List<Object> get props => [];
}

class TopRatedLoading extends TopRatedState {}

class TopRatedEmpty extends TopRatedState {}

class TopRatedError extends TopRatedState {
  final String message;

  const TopRatedError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedLoaded extends TopRatedState {
  final List<Movie> result;

  const TopRatedLoaded(this.result);

  @override
  List<Object> get props => [result];
}

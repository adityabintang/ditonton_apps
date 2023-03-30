part of 'top_rated_bloc.dart';

abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object> get props => [];
}

class TopRatedEmpty extends TopRatedTvState {}

class TopRatedLoading extends TopRatedTvState {}

class TopRatedError extends TopRatedTvState {
  final String message;

  const TopRatedError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedLoaded extends TopRatedTvState {
  final List<Tv> result;

  const TopRatedLoaded(this.result);

  @override
  List<Object> get props => [result];
}

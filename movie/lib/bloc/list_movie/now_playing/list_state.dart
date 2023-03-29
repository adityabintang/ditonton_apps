part of 'list_bloc.dart';

abstract class ListMovieState extends Equatable {
  const ListMovieState();

  @override
  List<Object> get props => [];
}

class ListNowPlayingLoading extends ListMovieState {}

class ListNowPlayingEmpty extends ListMovieState {}

class ListNowPlayingError extends ListMovieState {
  final String message;

  const ListNowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}

class ListNowPlayingLoaded extends ListMovieState {
  final List<Movie> result;

  const ListNowPlayingLoaded(this.result);

  @override
  List<Object> get props => [result];
}

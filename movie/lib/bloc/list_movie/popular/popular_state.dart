part of 'popular_bloc.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  List<Object> get props => [];
}

class ListPopularLoading extends PopularMovieState {}

class ListPopularEmpty extends PopularMovieState {}

class ListPopularError extends PopularMovieState {
  final String message;

  const ListPopularError(this.message);

  @override
  List<Object> get props => [message];
}

class ListPopularLoaded extends PopularMovieState {
  final List<Movie> result;

  const ListPopularLoaded(this.result);

  @override
  List<Object> get props => [result];
}

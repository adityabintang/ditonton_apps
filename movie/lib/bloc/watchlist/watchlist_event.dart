part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class WatchlistMovie extends WatchlistEvent {}

class WatchListMovieStatus extends WatchlistEvent {
  final int id;

  const WatchListMovieStatus(this.id);

  @override
  List<Object> get props => [id];
}

class SaveWatchlistMovie extends WatchlistEvent {
  final MovieDetail movieDetail;

  const SaveWatchlistMovie(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class RemoveWatchlistMovie extends WatchlistEvent {
  final MovieDetail movieDetail;

  const RemoveWatchlistMovie(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

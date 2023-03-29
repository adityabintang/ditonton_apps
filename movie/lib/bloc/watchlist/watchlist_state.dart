part of 'watchlist_bloc.dart';

abstract class WatchListState extends Equatable {
  const WatchListState();

  @override
  List<Object> get props => [];
}

class WatchListLoading extends WatchListState {}

class WatchListEmpty extends WatchListState {}

class WatchListError extends WatchListState {
  final String message;

  const WatchListError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistStatus extends WatchListState {
  final bool status;

  const WatchlistStatus(this.status);

  @override
  List<Object> get props => [status];
}

class WatchlistLoaded extends WatchListState {
  final List<Movie> result;

  const WatchlistLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class WatchListMessage extends WatchListState {
  final String message;

  const WatchListMessage(this.message);

  @override
  List<Object> get props => [message];
}

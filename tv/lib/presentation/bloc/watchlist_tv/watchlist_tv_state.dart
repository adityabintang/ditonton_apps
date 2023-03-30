part of 'watchlist_tv_bloc.dart';

abstract class WatchListTvState extends Equatable{
  const WatchListTvState();

  @override
  List<Object> get props => [];
}

class WatchListTvLoading extends WatchListTvState {}

class WatchListTvEmpty extends WatchListTvState {}

class WatchListTvError extends WatchListTvState {
  final String message;

  const WatchListTvError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchListStatusTv extends WatchListTvState {
  final bool status;

  const WatchListStatusTv(this.status);

  @override
  List<Object> get props => [status];
}

class WatchListTvLoaded extends WatchListTvState {
  final List<Tv> result;

  const WatchListTvLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class WatchListTvMessage extends WatchListTvState {
  final String message;

  const WatchListTvMessage(this.message);

  @override
  List<Object> get props => [message];
}

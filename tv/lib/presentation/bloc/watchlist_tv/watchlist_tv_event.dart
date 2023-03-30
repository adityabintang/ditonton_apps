part of 'watchlist_tv_bloc.dart';

abstract class WatchListTvEvent extends Equatable {
  const WatchListTvEvent();

  @override
  List<Object> get props => [];
}

class WatchListTv extends WatchListTvEvent {}

class WatchListTvStatus extends WatchListTvEvent {
  final int id;

  const WatchListTvStatus(this.id);

  @override
  List<Object> get props => [id];
}

class SaveWatchlistTv extends WatchListTvEvent {
  final TvSeriesDetail tvSeriesDetail;

  const SaveWatchlistTv(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class RemoveWatchlistTv extends WatchListTvEvent {
  final TvSeriesDetail tvSeriesDetail;

  const RemoveWatchlistTv(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}
import 'package:core/core.dart';
import 'package:search/search.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_series_detail.dart';

import '../../../tv.dart';

part 'watchlist_tv_event.dart';

part 'watchlist_tv_state.dart';

class WatchListTvBloc extends Bloc<WatchListTvEvent, WatchListTvState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;
  final GetWatchListStatusTvSeries getWatchListStatusTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';


  WatchListTvBloc(
    this.getWatchlistTvSeries,
    this.getWatchListStatusTvSeries,
    this.removeWatchlistTvSeries,
    this.saveWatchlistTvSeries,
  ) : super(WatchListTvEmpty()){
    on<WatchListTv>((event, emit) async {
      emit(WatchListTvLoading());

      final result = await getWatchlistTvSeries.execute();

      result.fold(
            (failure) {
          emit(WatchListTvError(failure.message));
        },
            (result) {
          emit(WatchListTvLoaded(result));
        },
      );
    });

    on<WatchListTvStatus>((event, emit) async {
      emit(WatchListTvLoading());

      final result = await getWatchListStatusTvSeries.execute(event.id);
      emit(WatchListStatusTv(result));
    });

    on<SaveWatchlistTv>((event, emit) async {
      emit(WatchListTvLoading());
      final result = await saveWatchlistTvSeries.execute(event.tvSeriesDetail);

      result.fold(
            (failure) => emit(WatchListTvError(failure.message)),
            (success) => emit(WatchListTvMessage(success)),
      );
    });

    on<RemoveWatchlistTv>((event, emit) async {
      emit(WatchListTvLoading());
      final result = await removeWatchlistTvSeries.execute(event.tvSeriesDetail);

      result.fold(
            (failure) => emit(WatchListTvError(failure.message)),
            (success) => emit(WatchListTvMessage(success)),
      );
    });
  }
}

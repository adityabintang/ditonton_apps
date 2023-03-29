import 'package:core/core.dart';
import 'package:search/search.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/usecase/get_watchlist_movies.dart';
import '../../domain/usecase/get_watchlist_status.dart';
import '../../domain/usecase/remove_watchlist.dart';
import '../../domain/usecase/save_watchlist.dart';

part 'watchlist_event.dart';

part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchListState> {
  final GetWatchlistMovies watchlistMovies;
  final GetWatchListStatus watchListStatus;
  final SaveWatchlist saveWatchlistMovie;
  final RemoveWatchlist removeWatchlistMovie;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistBloc(
    this.watchlistMovies,
    this.removeWatchlistMovie,
    this.saveWatchlistMovie,
    this.watchListStatus,
  ) : super(WatchListEmpty()) {
    on<WatchlistMovie>((event, emit) async {
      emit(WatchListLoading());

      final result = await watchlistMovies.execute();

      result.fold(
        (failure) {
          emit(WatchListError(failure.message));
        },
        (result) {
          emit(WatchlistLoaded(result));
        },
      );
    });

    on<WatchListMovieStatus>((event, emit) async {
      emit(WatchListLoading());

      final result = await watchListStatus.execute(event.id);
      emit(WatchlistStatus(result));
    });

    on<SaveWatchlistMovie>((event, emit) async {
      emit(WatchListLoading());
      final result = await saveWatchlistMovie.execute(event.movieDetail);

      result.fold(
        (failure) => emit(WatchListError(failure.message)),
        (success) => emit(WatchListMessage(success)),
      );
    });

    on<RemoveWatchlistMovie>((event, emit) async {
      emit(WatchListLoading());
      final result = await removeWatchlistMovie.execute(event.movieDetail);

      result.fold(
        (failure) => emit(WatchListError(failure.message)),
        (success) => emit(WatchListMessage(success)),
      );
    });
  }
}

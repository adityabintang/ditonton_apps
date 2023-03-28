import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_watchlist_tv_series.dart';

class WatchlistMovieNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];

  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistTvSeries = <Tv>[];

  List<Tv> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistState = RequestState.Empty;

  RequestState get watchlistState => _watchlistState;

  String _message = '';

  String get message => _message;

  WatchlistMovieNotifier({
    required this.getWatchlistMovies,
    this.getWatchlistTvSeries,
  });

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTvSeries? getWatchlistTvSeries;

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchWatchlistMoviesTvSeries() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvSeries?.execute();
    result?.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeries) {
        _watchlistState = RequestState.Loaded;
        _watchlistTvSeries = tvSeries;
        notifyListeners();
      },
    );
  }
}

import 'package:core/core.dart';
import 'package:search/search.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecase/get_now_playing_movies.dart';

part 'list_event.dart';

part 'list_state.dart';

class ListNowPlayingBloc extends Bloc<ListNowPlayingEvent, ListMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  ListNowPlayingBloc(
    this._getNowPlayingMovies,
  ) : super(ListNowPlayingEmpty()) {
    on<ListNowPlayingFetch>((event, emit) async {
      emit(ListNowPlayingLoading());
      final resultNowPlaying = await _getNowPlayingMovies.execute();
      resultNowPlaying.fold(
        (failure) {
          emit(ListNowPlayingError(failure.message));
        },
        (movie) {
          emit(ListNowPlayingLoaded(movie));
        },
      );
    });
  }
}

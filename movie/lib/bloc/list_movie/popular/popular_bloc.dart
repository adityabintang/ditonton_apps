import 'package:core/core.dart';
import 'package:movie/domain/usecase/get_popular_movies.dart';
import 'package:search/search.dart';

import '../../../domain/entities/movie.dart';

part 'popular_event.dart';

part 'popular_state.dart';

class ListPopularBloc extends Bloc<ListPopularEvent, PopularMovieState> {
  final GetPopularMovies _getPopularMovies;

  ListPopularBloc(
    this._getPopularMovies,
  ) : super(ListPopularEmpty()) {
    on<ListPopularFetch>((event, emit) async {
      emit(ListPopularLoading());
      final result = await _getPopularMovies.execute();
      result.fold(
        (failure) {
          emit(ListPopularError(failure.message));
        },
        (movie) {
          emit(ListPopularLoaded(movie));
        },
      );
    });
  }
}

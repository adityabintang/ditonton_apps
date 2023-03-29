import 'package:core/core.dart';
import 'package:search/search.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecase/get_top_rated_movies.dart';

part 'top_rated_event.dart';

part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedBloc(this._getTopRatedMovies) : super(TopRatedEmpty()) {
    on<TopRatedFetch>((event, emit) async {
      emit(TopRatedLoading());
      final result = await _getTopRatedMovies.execute();
      result.fold(
        (failure) {
          emit(TopRatedError(failure.message));
        },
        (movie) {
          emit(TopRatedLoaded(movie));
        },
      );
    });
  }
}

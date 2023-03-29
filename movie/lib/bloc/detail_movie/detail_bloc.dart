import 'package:core/core.dart';
import 'package:movie/domain/usecase/get_movie_detail.dart';
import 'package:search/search.dart';

import '../../domain/entities/movie_detail.dart';

part 'detail_event.dart';

part 'detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail detailMovie;

  MovieDetailBloc(this.detailMovie) : super(MovieDetailEmpty()) {
    on<MovieDetails>((event, emit) async {
      emit(MovieDetailLoading());
      final result = await detailMovie.execute(event.id);

      result.fold(
        (failure) {
          emit(MovieDetailError(failure.message));
        },
        (movie) {
          emit(MovieDetailLoaded(movie));
        },
      );
    });
  }
}

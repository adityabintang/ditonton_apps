import 'package:core/core.dart';
import 'package:movie/domain/usecase/get_movie_recommendations.dart';
import 'package:search/search.dart';

import '../../domain/entities/movie.dart';

part 'recom_event.dart';

part 'recom_state.dart';

class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  final GetMovieRecommendations getMovieRecommendations;

  RecommendationBloc(this.getMovieRecommendations)
      : super(RecommendationEmpty()) {
    on<RecommendationFetch>((event, emit) async {
      emit(RecommendationLoading());

      final result = await getMovieRecommendations.execute(event.id);

      result.fold(
        (failure) {
          emit(RecommendationError(failure.message));
        },
        (result) {
          emit(RecommendationLoaded(result));
        },
      );
    });
  }
}

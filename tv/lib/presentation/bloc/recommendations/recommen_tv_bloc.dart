import 'package:core/core.dart';
import 'package:search/search.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/get_tv_series_recommendations.dart';

part 'recommen_tv_event.dart';

part 'recommen_tv_state.dart';

class RecommendationTvBloc
    extends Bloc<RecommendationTvEvent, RecommendationTvState> {
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  RecommendationTvBloc(this.getTvSeriesRecommendations)
      : super(RecommendationTvEmpty()) {
    on<RecommendationTvFetch>((event, emit) async {
      emit(RecommendationTvLoading());

      final result = await getTvSeriesRecommendations.execute(event.id);

      result.fold(
        (failure) {
          emit(RecommendationTvError(failure.message));
        },
        (result) {
          emit(RecommendationTvLoaded(result));
        },
      );
    });
  }
}

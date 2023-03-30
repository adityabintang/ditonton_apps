import 'package:core/core.dart';
import 'package:search/search.dart';

import '../../../../domain/entities/tv.dart';
import '../../../../domain/usecases/get_top_rated_tv_series.dart';

part 'top_rated_state.dart';

part 'top_rated_event.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvBloc(this.getTopRatedTvSeries) : super(TopRatedEmpty()) {
    on<TopRatedFetch>((event, emit) async {
      emit(TopRatedLoading());

      final result = await getTopRatedTvSeries.execute();

      result.fold(
        (failure) {
          emit(TopRatedError(failure.message));
        },
        (result) {
          emit(TopRatedLoaded(result));
        },
      );
    });
  }
}

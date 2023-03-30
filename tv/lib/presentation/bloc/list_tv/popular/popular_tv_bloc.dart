import 'package:core/core.dart';
import 'package:search/search.dart';
import 'package:tv/domain/entities/tv.dart';

import '../../../../domain/usecases/get_popular_tv_series.dart';

part 'popular_tv_event.dart';

part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvBloc(this.getPopularTvSeries) : super(PopularTvEmpty()) {
    on<PopularTvFetch>((event, emit) async {
      emit(PopularTvLoading());

      final result = await getPopularTvSeries.execute();

      result.fold(
        (failure) {
          emit(PopularTvError(failure.message));
        },
        (result) {
          emit(PopularTvLoaded(result));
        },
      );
    });
  }
}

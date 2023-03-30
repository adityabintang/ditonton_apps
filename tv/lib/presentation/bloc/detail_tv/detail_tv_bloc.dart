import 'package:core/core.dart';
import 'package:search/search.dart';
import 'package:tv/domain/entities/tv_series_detail.dart';
import 'package:tv/domain/usecases/get_tv_series_detail.dart';

part 'detail_tv_event.dart';

part 'detail_tv_state.dart';

class DetailTvBloc extends Bloc<DetailTvEvent, DetailTvState> {
  final GetTvSeriesDetail getTvSeriesDetail;

  DetailTvBloc(this.getTvSeriesDetail) : super(DetailTvEmpty()) {
    on<DetailTvFetch>((event, emit) async {
      emit(DetailTVLoading());

      final result = await getTvSeriesDetail.execute(event.id);

      result.fold(
        (failure) {
          emit(DetailTvError(failure.message));
        },
        (result) {
          emit(DetailTvLoaded(result));
        },
      );
    });
  }
}

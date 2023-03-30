import 'package:core/core.dart';
import 'package:search/search.dart';

import '../../../../domain/entities/tv.dart';
import '../../../../domain/usecases/get_on_air_tv_series.dart';

part 'on_air_event.dart';

part 'on_air_state.dart';

class OnAirBloc extends Bloc<OnAirEvent, OnAirState> {
  final GetOnAirTvSeries getOnAirTvSeries;

  OnAirBloc(this.getOnAirTvSeries) : super(OnAirEmpty()) {
    on<OnAirFetch>((event, emit) async {
      emit(OnAirLoading());
      final result = await getOnAirTvSeries.execute();

      result.fold(
        (failure) {
          emit(OnAirError(failure.message));
        },
        (tv) {
          emit(OnAirLoaded(tv));
        },
      );
    });
  }
}

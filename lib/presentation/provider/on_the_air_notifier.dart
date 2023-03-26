import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_air_tv_series.dart';
import 'package:flutter/foundation.dart';

class OnAirNotifier extends ChangeNotifier{
  final GetOnAirTvSeries getOnAirTvSeries;

  OnAirNotifier(this.getOnAirTvSeries);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tvSeries = [];
  List<Tv> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnAirTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getOnAirTvSeries.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (tvSeries) {
        _tvSeries = tvSeries;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
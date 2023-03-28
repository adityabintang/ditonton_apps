import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import '../../domain/usecases/search_tv_series.dart';
import 'package:flutter/cupertino.dart';

class TvSeriesSearchNotifier extends ChangeNotifier {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchNotifier(this.searchTvSeries);

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _searchResult = [];

  List<Tv> get searchResult => _searchResult;

  String _message = '';

  String get message => _message;

  Future<void> fetchSearchTvSeries(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTvSeries.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}

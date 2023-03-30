import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/tv.dart';
import '../repositories/tv_series_repository.dart';

class GetWatchlistTvSeries {
  final TvSeriesRepository _repository;

  GetWatchlistTvSeries(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTvSeries();
  }
}

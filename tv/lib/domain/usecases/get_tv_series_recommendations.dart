import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/repositories/tv_series_repository.dart';

import '../entities/tv.dart';

class GetTvSeriesRecommendations {
  final TvSeriesRepository repository;

  GetTvSeriesRecommendations(this.repository);

  Future<Either<Failure, List<Tv>>> execute(id) {
    return repository.getRecommendationsTvSeries(id);
  }
}

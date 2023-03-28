import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/tv.dart';

class GetTvSeriesRecommendations {
  final TvSeriesRepository repository;

  GetTvSeriesRecommendations(this.repository);

  Future<Either<Failure, List<Tv>>> execute(id) {
    return repository.getRecommendationsTvSeries(id);
  }
}

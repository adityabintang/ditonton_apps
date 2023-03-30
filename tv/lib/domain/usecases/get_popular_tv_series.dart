import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/tv.dart';
import '../repositories/tv_series_repository.dart';

class GetPopularTvSeries {
  final TvSeriesRepository repository;

  GetPopularTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getPopularTvSeries();
  }
}

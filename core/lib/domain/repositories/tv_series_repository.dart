import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<Tv>>> getOnAirTvSeries();
  Future<Either<Failure, List<Tv>>> getPopularTvSeries();
  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries();
  Future<Either<Failure, List<Tv>>> searchTvSeries(String query);
  Future<Either<Failure, TvSeriesDetail>> getDetailTvSeries(int id);
  Future<Either<Failure, List<Tv>>> getRecommendationsTvSeries(int id);
  Future<Either<Failure, String>> saveWatchlist(TvSeriesDetail tvSeries);
  Future<Either<Failure, String>> removeWatchlist(TvSeriesDetail tvSeries);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTvSeries();
}

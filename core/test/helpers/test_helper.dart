import 'package:core/utils/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:http/io_client.dart';
import 'package:movie/data/datasource/db/database_helper_movie.dart';
import 'package:movie/data/datasource/movie_datasource/movie_local_data_source.dart';
import 'package:movie/data/datasource/movie_datasource/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:tv/data/datasources/db/database_helper_tv_series.dart';
import 'package:tv/data/datasources/tv_data_sources/tv_series_local_data_sources.dart';
import 'package:tv/data/datasources/tv_data_sources/tv_series_remote_data_sources.dart';
import 'package:tv/domain/repositories/tv_series_repository.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  NetworkInfo,
  DatabaseHelperTv,
  TvSeriesLocalDataSources,
  TvSeriesRemoteDataSource,
  TvSeriesRepository,
], customMocks: [
  MockSpec<IOClient>(as: #MockHttpClient)
])
void main() {}

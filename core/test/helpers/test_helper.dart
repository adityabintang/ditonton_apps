import 'package:core/data/datasources/db/database_helper_movie.dart';
import 'package:core/data/datasources/db/database_helper_tv_series.dart';
import 'package:core/data/datasources/movie_datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_data_sources/tv_series_local_data_sources.dart';
import 'package:core/data/datasources/tv_data_sources/tv_series_remote_data_sources.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/utils/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

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
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}

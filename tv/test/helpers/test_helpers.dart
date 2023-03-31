import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:tv/data/datasources/db/database_helper_tv_series.dart';
import 'package:tv/data/datasources/tv_data_sources/tv_series_local_data_sources.dart';
import 'package:tv/data/datasources/tv_data_sources/tv_series_remote_data_sources.dart';
import 'package:tv/domain/repositories/tv_series_repository.dart';

@GenerateMocks([
  DatabaseHelperTv,
  TvSeriesLocalDataSources,
  TvSeriesRemoteDataSource,
  TvSeriesRepository,
], customMocks: [
  MockSpec<IOClient>(as: #MockHttpClient)
])
void main() {}
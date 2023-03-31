import 'package:core/utils/network_info.dart';
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:movie/data/datasource/db/database_helper_movie.dart';
import 'package:movie/data/datasource/movie_datasource/movie_local_data_source.dart';
import 'package:movie/data/datasource/movie_datasource/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<IOClient>(as: #MockHttpClient)
])
void main() {}
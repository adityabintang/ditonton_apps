import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/db/database_helper_movie.dart';
import 'package:ditonton/data/datasources/movie_datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_datasources/movie_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  NetworkInfo
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}

import 'package:core/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/movie.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}

import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/list_movie/popular/popular_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecase/get_popular_movies.dart';

import 'popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late ListPopularBloc listPopularBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    listPopularBloc = ListPopularBloc(mockGetPopularMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  test('initial state should be empty', () {
    expect(listPopularBloc.state, ListPopularEmpty());
  });

  blocTest<ListPopularBloc, PopularMovieState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return listPopularBloc;
      },
      act: (bloc) => bloc.add(ListPopularFetch()),
      expect: () => [
            ListPopularLoading(),
            ListPopularLoaded(tMovieList),
          ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      });

  blocTest<ListPopularBloc, PopularMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return listPopularBloc;
    },
    act: (bloc) => bloc.add(ListPopularFetch()),
    expect: () => [
      ListPopularLoading(),
      const ListPopularError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );
}

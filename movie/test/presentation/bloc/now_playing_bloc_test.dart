import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/list_movie/now_playing/list_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecase/get_now_playing_movies.dart';

import 'now_playing_bloc_test.mocks.dart';


@GenerateMocks([GetNowPlayingMovies])
void main() {
  late ListNowPlayingBloc listNowPlayingBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    listNowPlayingBloc = ListNowPlayingBloc(mockGetNowPlayingMovies);
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
    expect(listNowPlayingBloc.state, ListNowPlayingEmpty());
  });

  blocTest<ListNowPlayingBloc, ListMovieState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return listNowPlayingBloc;
      },
      act: (bloc) => bloc.add(ListNowPlayingFetch()),
      expect: () => [ListNowPlayingLoading(), ListNowPlayingLoaded(tMovieList)],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      });

  blocTest<ListNowPlayingBloc, ListMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return listNowPlayingBloc;
    },
    act: (bloc) => bloc.add(ListNowPlayingFetch()),
    expect: () => [
      ListNowPlayingLoading(),
      const ListNowPlayingError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );
}

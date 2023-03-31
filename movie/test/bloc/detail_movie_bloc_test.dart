import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/detail_movie/detail_bloc.dart';
import 'package:movie/domain/usecase/get_movie_detail.dart';

import '../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  test(
    'initial state should be empty',
    () {
      expect(movieDetailBloc.state, MovieDetailEmpty());
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Right(testMovieDetail));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const MovieDetails(1)),
    expect: () => <MovieDetailState>[
      MovieDetailLoading(),
      MovieDetailLoaded(testMovieDetail),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(1));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits [Loading, Error] when get movie detail is unsuccessful.',
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const MovieDetails(1)),
    expect: () => <MovieDetailState>[
      MovieDetailLoading(),
      const MovieDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(1));
    },
  );
}

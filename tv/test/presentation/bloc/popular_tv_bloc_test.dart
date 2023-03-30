
import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tv_series.dart';
import 'package:tv/presentation/bloc/list_tv/popular/popular_tv_bloc.dart';

import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvBloc popularTvBloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    popularTvBloc = PopularTvBloc(mockGetPopularTvSeries);
  });

  final tTvSeries = Tv(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalLanguage: "en",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: 'posterPath',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
    originCountry: const ["US"],
    firstAirDate: "firstAirDate",
  );

  final tTv = <Tv>[tTvSeries];

  test('initial state should be empty', () {
    expect(popularTvBloc.state, PopularTvEmpty());
  });

  blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTv));
        return popularTvBloc;
      },
      act: (bloc) => bloc.add(PopularTvFetch()),
      expect: () => [
        PopularTvLoading(),
        PopularTvLoaded(tTv),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      });

  blocTest<PopularTvBloc, PopularTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(PopularTvFetch()),
    expect: () => [
      PopularTvLoading(),
      const PopularTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvSeries.execute());
    },
  );
}

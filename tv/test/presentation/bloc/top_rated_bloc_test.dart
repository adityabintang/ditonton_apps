import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv/presentation/bloc/list_tv/top_rated/top_rated_bloc.dart';

import 'top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TopRatedTvBloc topRatedTvBloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTvSeries);
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
    expect(topRatedTvBloc.state, TopRatedEmpty());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(tTv));
        return topRatedTvBloc;
      },
      act: (bloc) => bloc.add(TopRatedFetch()),
      expect: () => [
            TopRatedLoading(),
            TopRatedLoaded(tTv),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(TopRatedFetch()),
    expect: () => [
      TopRatedLoading(),
      const TopRatedError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    },
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/bloc/bloc_tv/search_bloc.dart';
import 'package:search/bloc/bloc_tv/search_event.dart';
import 'package:search/bloc/bloc_tv/search_state.dart';
import 'package:search/domain/usecases/search_tv_series.dart';

import 'tv_search_bloc.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSearchBloc tvSearchBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    tvSearchBloc = TvSearchBloc(mockSearchTvSeries);
  });

  final tTvSeriesModel = Tv(
    backdropPath: '/uDgy6hyPd82kOHh6I95FLtLnj6p.jpg',
    genreIds: const [18],
    id: 100088,
    originalLanguage: "en",
    originalName: "The Last of Us",
    overview:
        "Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.",
    popularity: 2372.319,
    posterPath: '/uDgy6hyPd82kOHh6I95FLtLnj6p.jpg',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
    originCountry: const ["US"],
    firstAirDate: "2023-01-15",
  );

  final tTvList = <Tv>[tTvSeriesModel];
  const tQuery = 'the last of us';

  test('initial state should be empty', () {
    expect(tvSearchBloc.state, TvSearchEmpty());
  });

  blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchTvSeries.execute(tQuery))
            .thenAnswer((_) async => Right(tTvList));
        return tvSearchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [TvSearchLoading(), TvSearchHasData(tTvList)],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      });

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSearchLoading(),
      const TvSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}

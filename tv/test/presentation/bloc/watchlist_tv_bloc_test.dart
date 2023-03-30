import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:tv/domain/usecases/save_watchlist_tv_series.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late WatchListTvBloc watchListTvBloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatusTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    mockGetWatchListStatusTvSeries = MockGetWatchListStatusTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    watchListTvBloc = WatchListTvBloc(
      mockGetWatchlistTvSeries,
      mockGetWatchListStatusTvSeries,
      mockRemoveWatchlistTvSeries,
      mockSaveWatchlistTvSeries,
    );
  });


  test(
    'initial state should be empty',
        () {
      expect(watchListTvBloc.state, WatchListTvEmpty());
    },
  );

  blocTest<WatchListTvBloc, WatchListTvState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      return watchListTvBloc;
    },
    act: (bloc) => bloc.add(WatchListTv()),
    expect: () => <WatchListTvState>[
      WatchListTvLoading(),
      WatchListTvLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvSeries.execute());
    },
  );

  blocTest<WatchListTvBloc, WatchListTvState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully.',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchListTvBloc;
    },
    act: (bloc) => bloc.add(WatchListTv()),
    expect: () => <WatchListTvState>[
      WatchListTvLoading(),
      const WatchListTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvSeries.execute());
    },
  );

  blocTest<WatchListTvBloc, WatchListTvState>(
    'should emit [Loading, MovieWatchlistStatus] when data is gotten successfully',
    build: () {
      when(mockGetWatchListStatusTvSeries.execute(testTv.id))
          .thenAnswer((_) async => true);
      return watchListTvBloc;
    },
    act: (bloc) => bloc.add(WatchListTvStatus(testTv.id!)),
    expect: () => <WatchListTvState>[
      WatchListTvLoading(),
      const WatchListStatusTv(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatusTvSeries.execute(testTv.id));
    },
  );

  blocTest<WatchListTvBloc, WatchListTvState>(
    'should emit [Loading, WatchlistMovieMessage] when save to watchlist is successful',
    build: () {
      when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail)).thenAnswer(
              (_) async => const Right(WatchListTvBloc.watchlistAddSuccessMessage));
      when(mockGetWatchListStatusTvSeries.execute(testTv.id))
          .thenAnswer((_) async => true);
      return watchListTvBloc;
    },
    act: (bloc) => bloc.add(SaveWatchlistTv(testTvSeriesDetail)),
    expect: () => <WatchListTvState>[
      WatchListTvLoading(),
      const WatchListTvMessage(WatchListTvBloc.watchlistAddSuccessMessage),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
    },
  );

  blocTest<WatchListTvBloc, WatchListTvState>(
    'should emit [Loading, WatchlistMovieMessage] when remove watchlist is successful',
    build: () {
      when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail)).thenAnswer((_) async =>
      const Right(WatchListTvBloc.watchlistRemoveSuccessMessage));
      when(mockGetWatchListStatusTvSeries.execute(testTv.id))
          .thenAnswer((_) async => false);
      return watchListTvBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistTv(testTvSeriesDetail)),
    expect: () => <WatchListTvState>[
      WatchListTvLoading(),
      const WatchListTvMessage(WatchListTvBloc.watchlistRemoveSuccessMessage),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
    },
  );

  blocTest<WatchListTvBloc, WatchListTvState>(
    'should emit [Loading, Error] when add watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      when(mockGetWatchListStatusTvSeries.execute(testTv.id))
          .thenAnswer((_) async => false);
      return watchListTvBloc;
    },
    act: (bloc) => bloc.add(SaveWatchlistTv(testTvSeriesDetail)),
    expect: () => <WatchListTvState>[
      WatchListTvLoading(),
      const WatchListTvError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
    },
  );

  blocTest<WatchListTvBloc, WatchListTvState>(
    'should emit [Loading, Error] when remove watchlist is unsuccessful',
    build: () {
      when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      when(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => true);
      return watchListTvBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistTv(testTvSeriesDetail)),
    expect: () => <WatchListTvState>[
      WatchListTvLoading(),
      const WatchListTvError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
    },
  );
}

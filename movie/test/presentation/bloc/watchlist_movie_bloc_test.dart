import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/watchlist/watchlist_bloc.dart';
import 'package:movie/domain/usecase/get_watchlist_movies.dart';
import 'package:movie/domain/usecase/get_watchlist_status.dart';
import 'package:movie/domain/usecase/remove_watchlist.dart';
import 'package:movie/domain/usecase/save_watchlist.dart';
import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatus,
  GetWatchlistMovies,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late WatchlistBloc watchlistBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistBloc = WatchlistBloc(
      mockGetWatchlistMovies,
      mockRemoveWatchlist,
      mockSaveWatchlist,
      mockGetWatchListStatus,
    );
  });

  test(
    'initial state should be empty',
    () {
      expect(watchlistBloc.state, WatchListEmpty());
    },
  );

  blocTest<WatchlistBloc, WatchListState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(WatchlistMovie()),
    expect: () => <WatchListState>[
      WatchListLoading(),
      WatchlistLoaded(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistBloc, WatchListState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully.',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(WatchlistMovie()),
    expect: () => <WatchListState>[
      WatchListLoading(),
      const WatchListError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistBloc, WatchListState>(
    'should emit [Loading, MovieWatchlistStatus] when data is gotten successfully',
    build: () {
      when(mockGetWatchListStatus.execute(testMovie.id))
          .thenAnswer((_) async => true);
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(WatchListMovieStatus(testMovie.id)),
    expect: () => <WatchListState>[
      WatchListLoading(),
      const WatchlistStatus(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(testMovie.id));
    },
  );

  blocTest<WatchlistBloc, WatchListState>(
    'should emit [Loading, WatchlistMovieMessage] when save to watchlist is successful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async => const Right(WatchlistBloc.watchlistAddSuccessMessage));
      when(mockGetWatchListStatus.execute(testMovie.id))
          .thenAnswer((_) async => true);
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(SaveWatchlistMovie(testMovieDetail)),
    expect: () => <WatchListState>[
      WatchListLoading(),
      const WatchListMessage(WatchlistBloc.watchlistAddSuccessMessage),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<WatchlistBloc, WatchListState>(
    'should emit [Loading, WatchlistMovieMessage] when remove watchlist is successful',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async =>
          const Right(WatchlistBloc.watchlistRemoveSuccessMessage));
      when(mockGetWatchListStatus.execute(testMovie.id))
          .thenAnswer((_) async => false);
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistMovie(testMovieDetail)),
    expect: () => <WatchListState>[
      WatchListLoading(),
      const WatchListMessage(WatchlistBloc.watchlistRemoveSuccessMessage),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<WatchlistBloc, WatchListState>(
    'should emit [Loading, Error] when add watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(SaveWatchlistMovie(testMovieDetail)),
    expect: () => <WatchListState>[
      WatchListLoading(),
      const WatchListError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<WatchlistBloc, WatchListState>(
    'should emit [Loading, Error] when remove watchlist is unsuccessful',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistMovie(testMovieDetail)),
    wait: const Duration(milliseconds: 500),
    expect: () => <WatchListState>[
      WatchListLoading(),
      const WatchListError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );
}

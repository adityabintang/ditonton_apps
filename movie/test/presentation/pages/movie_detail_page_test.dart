import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/detail_movie/detail_bloc.dart';
import 'package:movie/bloc/recommendations/recom_bloc.dart';
import 'package:movie/bloc/watchlist/watchlist_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search/search.dart';
import '../../dummy_data/dummy_objects.dart';

class MovieEventFake extends Fake implements MovieDetailEvent {}

class MovieStateFake extends Fake implements MovieDetailState {}

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockRecommendationBloc
    extends MockBloc<RecommendationEvent, RecommendationState>
    implements RecommendationBloc {}

class MockMovieWatchlistBloc extends MockBloc<WatchlistEvent, WatchListState>
    implements WatchlistBloc {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockRecommendationBloc mockRecommendationBloc;
  late MockMovieWatchlistBloc mockMovieWatchlistBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockRecommendationBloc = MockRecommendationBloc();
    mockMovieWatchlistBloc = MockMovieWatchlistBloc();
    registerFallbackValue(MovieEventFake());
    registerFallbackValue(MovieStateFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (context) => mockMovieDetailBloc,
        ),
        BlocProvider<WatchlistBloc>(
          create: (context) => mockMovieWatchlistBloc,
        ),
        BlocProvider<RecommendationBloc>(
          create: (context) => mockRecommendationBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(const WatchlistStatus(false));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationLoaded(testMovieList));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(
        _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(const WatchlistStatus(true));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationLoaded(testMovieList));

    final watchlistButtonIcon = find.byIcon(Icons.check);
    await tester.pumpWidget(
        _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationLoaded(testMovieList));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(const WatchlistStatus(false));
    when(() => mockMovieWatchlistBloc.state).thenReturn(
        const WatchListMessage(WatchlistBloc.watchlistAddSuccessMessage));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(
        _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(WatchlistBloc.watchlistAddSuccessMessage), findsOneWidget);
  });
  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => mockRecommendationBloc.state)
        .thenReturn(RecommendationLoaded(testMovieList));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(const WatchlistStatus(false));
    when(() => mockMovieWatchlistBloc.state)
        .thenReturn(const WatchListError('Failed'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(
        _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}

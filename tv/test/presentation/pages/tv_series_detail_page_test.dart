import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/search.dart';
import 'package:tv/presentation/bloc/detail_tv/detail_tv_bloc.dart';
import 'package:tv/presentation/bloc/recommendations/recommen_tv_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:tv/presentation/pages/tv_series_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class TvEventFake extends Fake implements DetailTvEvent {}

class TvStateFake extends Fake implements DetailTvState {}

class MockTvDetailBloc extends MockBloc<DetailTvEvent, DetailTvState>
    implements DetailTvBloc {}

class MockRecommendationBloc
    extends MockBloc<RecommendationTvEvent, RecommendationTvState>
    implements RecommendationTvBloc {}

class MockTvWatchlistBloc extends MockBloc<WatchListTvEvent, WatchListTvState>
    implements WatchListTvBloc {}

void main() {
  late MockTvDetailBloc mockMovieDetailBloc;
  late MockRecommendationBloc mockRecommendationBloc;
  late MockTvWatchlistBloc mockTvWatchlistBloc;

  setUp(() {
    mockMovieDetailBloc = MockTvDetailBloc();
    mockRecommendationBloc = MockRecommendationBloc();
    mockTvWatchlistBloc = MockTvWatchlistBloc();
    registerFallbackValue(TvEventFake());
    registerFallbackValue(TvStateFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailTvBloc>(
          create: (context) => mockMovieDetailBloc,
        ),
        BlocProvider<WatchListTvBloc>(
          create: (context) => mockTvWatchlistBloc,
        ),
        BlocProvider<RecommendationTvBloc>(
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
            .thenReturn(DetailTvLoaded(testTvSeriesDetail));
        when(() => mockTvWatchlistBloc.state)
            .thenReturn(const WatchListStatusTv(false));
        when(() => mockRecommendationBloc.state)
            .thenReturn(RecommendationTvLoaded(testTvList));

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(
            _makeTestableWidget(TvSeriesDetailPage(id: testTvSeriesDetail.id)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display check icon when movie not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.state)
            .thenReturn(DetailTvLoaded(testTvSeriesDetail));
        when(() => mockTvWatchlistBloc.state)
            .thenReturn(const WatchListStatusTv(true));
        when(() => mockRecommendationBloc.state)
            .thenReturn(RecommendationTvLoaded(testTvList));

        final watchlistButtonIcon = find.byIcon(Icons.check);
        await tester.pumpWidget(
            _makeTestableWidget(TvSeriesDetailPage(id: testTvSeriesDetail.id)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.state)
            .thenReturn(DetailTvLoaded(testTvSeriesDetail));
        when(() => mockRecommendationBloc.state)
            .thenReturn(RecommendationTvLoaded(testTvList));
        when(() => mockTvWatchlistBloc.state)
            .thenReturn(const WatchListStatusTv(false));
        when(() => mockTvWatchlistBloc.state).thenReturn(
            const WatchListTvMessage(WatchListTvBloc.watchlistAddSuccessMessage));

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(
            _makeTestableWidget(TvSeriesDetailPage(id: testTvSeriesDetail.id)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(WatchListTvBloc.watchlistAddSuccessMessage), findsOneWidget);
      });
  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.state)
            .thenReturn(DetailTvLoaded(testTvSeriesDetail));
        when(() => mockRecommendationBloc.state)
            .thenReturn(RecommendationTvLoaded(testTvList));
        when(() => mockTvWatchlistBloc.state)
            .thenReturn(const WatchListStatusTv(false));
        when(() => mockTvWatchlistBloc.state)
            .thenReturn(const WatchListTvError('Failed'));

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(
            _makeTestableWidget(TvSeriesDetailPage(id: testTvSeriesDetail.id)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/search.dart';
import 'package:tv/presentation/bloc/list_tv/popular/popular_tv_bloc.dart';
import 'package:tv/presentation/pages/popular_tv_series_page.dart';
import '../../dummy_data/dummy_objects.dart';

class PopularTvEventFake extends Fake implements PopularTvEvent {}

class PopularTvStateFake extends Fake implements PopularTvState {}

class MockPopularBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

void main() {
  late MockPopularBloc mockNotifier;

  setUp(() {
    mockNotifier = MockPopularBloc();
    registerFallbackValue(PopularTvEventFake());
    registerFallbackValue(PopularTvStateFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>(
      create: (_) => mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockNotifier.state).thenReturn(PopularTvLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockNotifier.state).thenReturn(PopularTvLoaded(testTvList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockNotifier.state)
            .thenReturn(const PopularTvError('Error Message'));

        final textFinder = find.byKey(const Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}

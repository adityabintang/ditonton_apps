import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/search.dart';
import 'package:tv/presentation/bloc/list_tv/top_rated/top_rated_bloc.dart';
import 'package:tv/presentation/pages/top_rated_tv_series_page.dart';

import '../../dummy_data/dummy_objects.dart';

class TopRatedTvEventFake extends Fake implements TopRatedTvEvent {}

class TopRatedTvStateFake extends Fake implements TopRatedTvState {}

class MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

void main() {
  late MockTopRatedTvBloc mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedTvBloc();
    registerFallbackValue(TopRatedTvEventFake());
    registerFallbackValue(TopRatedTvStateFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>(
      create: (_) => mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(TopRatedLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(TopRatedLoaded(testTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockNotifier.state)
        .thenReturn(const TopRatedError('Error Message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}

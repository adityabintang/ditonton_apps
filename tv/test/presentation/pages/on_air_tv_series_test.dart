import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/search.dart';
import 'package:tv/presentation/bloc/list_tv/on_air/on_air_bloc.dart';
import 'package:tv/presentation/pages/on_air_tv_series_page.dart';

import '../../dummy_data/dummy_objects.dart';

class OnAirEventFake extends Fake implements OnAirEvent {}

class OnAirStateFake extends Fake implements OnAirState {}

class MockOnAirTvBloc extends MockBloc<OnAirEvent, OnAirState>
    implements OnAirBloc {}

void main() {
  late MockOnAirTvBloc mockNotifier;

  setUp(() {
    mockNotifier = MockOnAirTvBloc();
    registerFallbackValue(OnAirEventFake());
    registerFallbackValue(OnAirStateFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<OnAirBloc>(
      create: (_) => mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(OnAirLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const OnAirTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(OnAirLoaded(testTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const OnAirTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockNotifier.state)
        .thenReturn(const OnAirError('Error Message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const OnAirTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}

import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_on_air_tv_series.dart';
import 'package:core/presentation/provider/on_the_air_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_the_air_notifier.mocks.dart';

@GenerateMocks([GetOnAirTvSeries])
void main() {
  late MockGetOnAirTvSeries mockGetOnAirTvSeries;
  late OnAirNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnAirTvSeries = MockGetOnAirTvSeries();
    notifier = OnAirNotifier(mockGetOnAirTvSeries)
      ..addListener(() {
        listenerCallCount++;
      });
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

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetOnAirTvSeries.execute()).thenAnswer((_) async => Right(tTv));
    // act
    notifier.fetchOnAirTvSeries();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetOnAirTvSeries.execute()).thenAnswer((_) async => Right(tTv));
    // act
    await notifier.fetchOnAirTvSeries();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvSeries, tTv);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetOnAirTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchOnAirTvSeries();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}

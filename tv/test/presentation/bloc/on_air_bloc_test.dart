import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_air_tv_series.dart';
import 'package:tv/presentation/bloc/list_tv/on_air/on_air_bloc.dart';

import 'on_air_bloc_test.mocks.dart';

@GenerateMocks([GetOnAirTvSeries])
void main() {
  late OnAirBloc onAirBloc;
  late MockGetOnAirTvSeries mockGetOnAirTvSeries;

  setUp(() {
    mockGetOnAirTvSeries = MockGetOnAirTvSeries();
    onAirBloc = OnAirBloc(mockGetOnAirTvSeries);
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
    expect(onAirBloc.state, OnAirEmpty());
  });

  blocTest<OnAirBloc, OnAirState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetOnAirTvSeries.execute())
            .thenAnswer((_) async => Right(tTv));
        return onAirBloc;
      },
      act: (bloc) => bloc.add(OnAirFetch()),
      expect: () => [
            OnAirLoading(),
            OnAirLoaded(tTv),
          ],
      verify: (bloc) {
        verify(mockGetOnAirTvSeries.execute());
      });

  blocTest<OnAirBloc, OnAirState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return onAirBloc;
    },
    act: (bloc) => bloc.add(OnAirFetch()),
    expect: () => [
      OnAirLoading(),
      const OnAirError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnAirTvSeries.execute());
    },
  );
}

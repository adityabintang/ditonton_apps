import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_series.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../dummy_data/dummy_objects.dart';

void main() {
  late GetWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTvSeries(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockMovieRepository.getWatchlistTvSeries())
        .thenAnswer((_) async => Right(testTvList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvList));
  });
}

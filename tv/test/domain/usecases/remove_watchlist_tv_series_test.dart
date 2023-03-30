import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv_series.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../dummy_data/dummy_objects.dart';

void main() {
  late RemoveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlistTvSeries(mockMovieRepository);
  });

  test('should remove watchlist tv from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockMovieRepository.removeWatchlist(testTvSeriesDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}

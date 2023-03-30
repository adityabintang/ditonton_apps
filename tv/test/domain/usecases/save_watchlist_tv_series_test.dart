import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/save_watchlist_tv_series.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../dummy_data/dummy_objects.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvSeriesRepository();
    usecase = SaveWatchlistTvSeries(mockMovieRepository);
  });

  test('should save tv to the repository', () async {
    // arrange
    when(mockMovieRepository.saveWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockMovieRepository.saveWatchlist(testTvSeriesDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}

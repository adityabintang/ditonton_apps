import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv_series.dart';

import '../../helpers/test_helpers.mocks.dart';

void main() {
  late GetWatchListStatusTvSeries usecase;
  late MockTvSeriesRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvSeriesRepository();
    usecase = GetWatchListStatusTvSeries(mockMovieRepository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(mockMovieRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}

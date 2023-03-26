import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvSeriesRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvSeriesRepository();
    usecase = SearchTvSeries(mockMovieRepository);
  });

  final tTv = <Tv>[];
  final tQuery = 'the last of us';

  test('should get list of tv from the repository', () async {
    // arrange
    when(mockMovieRepository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTv));
  });
}

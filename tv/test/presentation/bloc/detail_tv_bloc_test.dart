import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_series_detail.dart';
import 'package:tv/presentation/bloc/detail_tv/detail_tv_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetail extends Fake implements GetTvSeriesDetail{}
void main() {
  late DetailTvBloc detailTvBloc;
  late MockTvSeriesDetail mockGetTvSeriesDetail;

  setUp(() {
    mockGetTvSeriesDetail = MockTvSeriesDetail();
    detailTvBloc = DetailTvBloc(mockGetTvSeriesDetail);
  });

  test(
    'initial state should be empty',
    () {
      expect(detailTvBloc.state, DetailTvEmpty());
    },
  );

  blocTest<DetailTvBloc, DetailTvState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesDetail.execute(1))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      return detailTvBloc;
    },
    act: (bloc) => bloc.add(const DetailTvFetch(1)),
    expect: () => <DetailTvState>[
      DetailTVLoading(),
      DetailTvLoaded(testTvSeriesDetail),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(1));
    },
  );

  blocTest<DetailTvBloc, DetailTvState>(
    'emits [Loading, Error] when get movie detail is unsuccessful.',
    build: () {
      when(mockGetTvSeriesDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailTvBloc;
    },
    act: (bloc) => bloc.add(const DetailTvFetch(1)),
    expect: () => <DetailTvState>[
      DetailTVLoading(),
      const DetailTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(1));
    },
  );
}

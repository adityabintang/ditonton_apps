import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalName: 'Original Name',
    originCountry: ['IN'],
    originalLanguage: 'en',
    overview: 'Overview',
    popularity: 1,
    posterPath: '/path.jpg',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
    firstAirDate: '2020-05-05',
  );
  final tTvSeriesResponseModel =
  TvSeriesResponse(tvList: <TvSeriesModel>[tTvSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(readJson('dummy_data/on_the_air.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        'results': [
          {
            'backdrop_path': '/path.jpg',
            'first_air_date': '2020-05-05',
            'genre_ids': [1, 2, 3, 4],
            'id': 1,
            'name': 'name',
            'origin_country': ['IN'],
            'original_language': 'en',
            'original_name': 'Original Name',
            'overview': 'Overview',
            'popularity': 1.0,
            'poster_path': '/path.jpg',
            'vote_average': 1.0,
            'vote_count': 1
          }
        ]
      };
      expect(result, expectedJsonMap);
    });
  });
}
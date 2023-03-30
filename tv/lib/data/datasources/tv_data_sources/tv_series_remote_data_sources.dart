import 'dart:convert';
import 'package:core/utils/exception.dart';
import 'package:http/io_client.dart';
import '../../models/tv_series_detail_model.dart';
import '../../models/tv_series_model.dart';
import '../../models/tv_series_response.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getOnAirTvSeries();
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<TvSeriesDetailModel> getDetailTvSeries(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
  Future<List<TvSeriesModel>> getRecommendationsTvSeries(int id);
}

class TvSeriesRemoteDataSourceImpl extends TvSeriesRemoteDataSource {
  static const API_KEY = 'api_key=c2de34c85692bf92c16ed8f453906988';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final IOClient client;

  TvSeriesRemoteDataSourceImpl({required this.client});



  @override
  Future<List<TvSeriesModel>> getOnAirTvSeries() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesDetailModel> getDetailTvSeries(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));
    if (response.statusCode == 200) {
      return TvSeriesDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getRecommendationsTvSeries(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}

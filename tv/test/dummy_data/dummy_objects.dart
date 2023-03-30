import 'package:movie/domain/entities/genre.dart';
import 'package:tv/data/models/tv_series_table.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_series_detail.dart';

final testTv = Tv(
  backdropPath: '/uDgy6hyPd82kOHh6I95FLtLnj6p.jpg',
  genreIds: const [18],
  id: 100088,
  originalLanguage: "en",
  originalName: "The Last of Us",
  overview:
      "Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.",
  popularity: 2372.319,
  posterPath: '/uDgy6hyPd82kOHh6I95FLtLnj6p.jpg',
  name: 'Spider-Man',
  voteAverage: 7.2,
  voteCount: 13507,
  originCountry: const ["US"],
  firstAirDate: "2023-01-15",
);
final testTvList = [testTv];

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
  homepage: 'https://google.com',
  originalLanguage: 'en',
  popularity: 1,
  status: 'Status',
  tagline: 'Tagline',
);

final testWatchlistTvSeries = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

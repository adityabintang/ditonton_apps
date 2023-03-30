import 'package:core/core.dart';
import 'package:core/utils/general_function.dart';
import 'package:flutter/material.dart';
import 'package:search/search.dart';
import 'package:tv/presentation/bloc/detail_tv/detail_tv_bloc.dart';
import 'package:tv/presentation/bloc/recommendations/recommen_tv_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_series_detail.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-series';

  final int id;

  const TvSeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailTvBloc>().add(DetailTvFetch(widget.id));
    context.read<RecommendationTvBloc>().add(RecommendationTvFetch(widget.id));
    context.read<WatchListTvBloc>().add(WatchListTvStatus(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailTvBloc, DetailTvState>(
        builder: (context, state) {
          if (state is DetailTVLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailTvLoaded) {
            final tvSeries = state.result;
            final recommendations = context
                .select<RecommendationTvBloc, List<Tv>>(
                    (RecommendationTvBloc result) {
              final state = result.state;
              return state is RecommendationTvLoaded ? state.result : [];
            });
            final isAddedWatchlist =
                context.select<WatchListTvBloc, bool>((WatchListTvBloc result) {
              final state = result.state;
              return state is WatchListStatusTv ? state.status : false;
            });
            return SafeArea(
              child: DetailContentTvSeries(
                  tvSeries, recommendations, isAddedWatchlist),
            );
          } else if (state is DetailTvError) {
            return Text(state.message);
          } else {
            return const Text('Failed');
          }
        },
      ),
    );
  }
}

class DetailContentTvSeries extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final List<Tv> recommendations;
  final bool isAddedToWatchlist;

  const DetailContentTvSeries(
      this.tvSeries, this.recommendations, this.isAddedToWatchlist,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvSeries.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedToWatchlist) {
                                  context
                                      .read<WatchListTvBloc>()
                                      .add(SaveWatchlistTv(tvSeries));
                                } else {
                                  context
                                      .read<WatchListTvBloc>()
                                      .add(RemoveWatchlistTv(tvSeries));
                                }

                                String message = !isAddedToWatchlist
                                    ? WatchListTvBloc.watchlistAddSuccessMessage
                                    : WatchListTvBloc
                                        .watchlistRemoveSuccessMessage;

                                final state =
                                    BlocProvider.of<WatchListTvBloc>(context)
                                        .state;

                                if (state is WatchListTvMessage ||
                                    state is WatchListStatusTv) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                  BlocProvider.of<WatchListTvBloc>(context)
                                      .add(WatchListTvStatus(tvSeries.id));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text('Failed'),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedToWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              showGenres(tvSeries.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvSeries.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationTvBloc,
                                RecommendationTvState>(
                              builder: (context, state) {
                                if (state is RecommendationTvLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is RecommendationTvError) {
                                  return Text(state.message);
                                } else if (state is RecommendationTvLoaded) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final recommendation =
                                            recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.ROUTE_NAME,
                                                arguments: recommendation.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${recommendation.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}

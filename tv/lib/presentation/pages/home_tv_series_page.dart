import 'package:search/search.dart';
import 'package:tv/presentation/bloc/list_tv/on_air/on_air_bloc.dart';
import 'package:tv/presentation/bloc/list_tv/popular/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/list_tv/top_rated/top_rated_bloc.dart';
import 'package:tv/presentation/pages/tv_series_detail_page.dart';
import 'on_air_tv_series_page.dart';
import 'popular_tv_series_page.dart';
import 'top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../domain/entities/tv.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-series';

  const HomeTvPage({Key? key}) : super(key: key);

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<OnAirBloc>().add(OnAirFetch());
    context.read<PopularTvBloc>().add(PopularTvFetch());
    context.read<TopRatedTvBloc>().add(TopRatedFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tv Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvSeriesPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                key: 'on_the_air_tv',
                title: 'On The Air',
                onTap: () =>
                    Navigator.pushNamed(context, OnAirTvSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<OnAirBloc, OnAirState>(
                builder: (context, state) {
                  if (state is OnAirLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is OnAirLoaded) {
                    return TvList(state.onAirTv);
                  } else if (state is OnAirError) {
                    return Expanded(
                      child: Center(
                        child: Text(state.message),
                      ),
                    );
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                key: 'popular_tv',
                title: 'Popular',
                onTap: () => Navigator.pushNamed(
                    context, PopularTvSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTvBloc, PopularTvState>(
                  builder: (context, state) {
                if (state is PopularTvLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTvLoaded) {
                  return TvList(state.result);
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                key: 'top_rated_tv',
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                    context, TopRatedTvSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                builder: (context, state) {
                  if (state is TopRatedLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedLoaded) {
                    return TvList(state.result);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap, required String key}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          key: Key(key),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> onAirTvSeries;

  const TvList(this.onAirTvSeries, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: onAirTvSeries.length >= 10 ? 5 : onAirTvSeries.length,
        itemBuilder: (context, index) {
          final tvSeries = onAirTvSeries[index];
          return Container(
            key: Key('tv_series_$index'),
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: tvSeries.id,
                );
                debugPrint('${tvSeries.id}');
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseUrlImage${tvSeries.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

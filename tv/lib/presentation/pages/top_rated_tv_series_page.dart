import 'package:core/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:search/search.dart';
import 'package:tv/presentation/bloc/list_tv/top_rated/top_rated_bloc.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';
  const TopRatedTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<TopRatedTvBloc>().add(TopRatedFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            if (state is TopRatedLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is TopRatedLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.result[index];
                  return TvSeriesCard(tvSeries, index);
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Text('Failed');
            }
          },
        ),
      ),
    );
  }
}

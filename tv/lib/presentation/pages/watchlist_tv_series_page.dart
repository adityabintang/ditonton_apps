
import 'package:core/utils/utils.dart';
import 'package:core/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:search/search.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  const WatchlistTvSeriesPage({Key? key}) : super(key: key);

  @override
  _WatchlistTvSeriesPageState createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<WatchListTvBloc>().add(WatchListTv());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchListTvBloc>().add(WatchListTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchListTvBloc, WatchListTvState>(
          builder: (context, state) {
            if (state is WatchListTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchListTvLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.result[index];
                  return TvSeriesCard(tvSeries, index);
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchListTvError) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

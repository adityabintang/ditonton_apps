import 'package:core/presentation/provider/on_the_air_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/state_enum.dart';
import '../widgets/tv_series_card.dart';

class OnAirTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-air-tv-series';
  const OnAirTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<OnAirTvSeriesPage> createState() => _OnAirTvSeriesPageState();
}

class _OnAirTvSeriesPageState extends State<OnAirTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<OnAirNotifier>(context, listen: false)
        .fetchOnAirTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<OnAirNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: data.tvSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/on_the_air_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Future.microtask(() =>
        Provider.of<OnAirNotifier>(context, listen: false)
            .fetchOnAirTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Series'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Consumer<OnAirNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
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
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}

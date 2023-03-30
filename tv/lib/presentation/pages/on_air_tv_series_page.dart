import 'package:core/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:search/search.dart';
import 'package:tv/presentation/bloc/list_tv/on_air/on_air_bloc.dart';

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
    context.read<OnAirBloc>().add(OnAirFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On Air Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnAirBloc, OnAirState>(
          builder: (context, state) {
            if (state is OnAirLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is OnAirLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.onAirTv[index];
                  return TvSeriesCard(tvSeries, index);
                },
                itemCount: state.onAirTv.length,
              );
            } else if (state is OnAirError) {
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

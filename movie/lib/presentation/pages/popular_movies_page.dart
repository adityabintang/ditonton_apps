import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:movie/bloc/list_movie/popular/popular_bloc.dart';
import 'package:search/search.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ListPopularBloc>().add(ListPopularFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<ListPopularBloc, PopularMovieState>(
          builder: (context, state) {
            if (state is ListPopularLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ListPopularLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is ListPopularError){
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }else{
              return const Text('Failed');
            }
          },
        ),
      ),
    );
  }
}

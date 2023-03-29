part of 'detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class MovieDetails extends MovieDetailEvent {
  final int id;

  const MovieDetails(this.id);

  @override
  List<Object> get props => [id];
}

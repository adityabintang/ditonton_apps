part of 'top_rated_bloc.dart';

abstract class TopRatedTvEvent extends Equatable {
  const TopRatedTvEvent();

  @override
  List<Object> get props => [];
}

class TopRatedFetch extends TopRatedTvEvent {}

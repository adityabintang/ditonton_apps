part of 'popular_bloc.dart';

abstract class ListPopularEvent extends Equatable {
  const ListPopularEvent();

  @override
  List<Object> get props => [];
}

class ListPopularFetch extends ListPopularEvent {}

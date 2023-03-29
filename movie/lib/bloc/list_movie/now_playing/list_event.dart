part of 'list_bloc.dart';

abstract class ListNowPlayingEvent extends Equatable {
  const ListNowPlayingEvent();

  @override
  List<Object> get props => [];
}

class ListNowPlayingFetch extends ListNowPlayingEvent {}

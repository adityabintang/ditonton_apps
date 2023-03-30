part of 'on_air_bloc.dart';

abstract class OnAirEvent extends Equatable {
  const OnAirEvent();

  @override
  List<Object> get props => [];
}

class OnAirFetch extends OnAirEvent {}

part of 'on_air_bloc.dart';

abstract class OnAirState extends Equatable {
  const OnAirState();

  @override
  List<Object> get props => [];
}

class OnAirLoading extends OnAirState {}

class OnAirEmpty extends OnAirState {}

class OnAirError extends OnAirState {
  final String message;

  const OnAirError(this.message);

  @override
  List<Object> get props => [message];
}

class OnAirLoaded extends OnAirState {
  final List<Tv> onAirTv;

  const OnAirLoaded(this.onAirTv);

  @override
  List<Object> get props => [onAirTv];
}

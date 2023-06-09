import 'package:core/core.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends TvSearchEvent {
  final String query;

  const OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

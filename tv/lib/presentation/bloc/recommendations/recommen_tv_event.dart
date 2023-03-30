part of 'recommen_tv_bloc.dart';

abstract class RecommendationTvEvent extends Equatable{
  const RecommendationTvEvent();

  @override
  List<Object> get props => [];
}

class RecommendationTvFetch extends RecommendationTvEvent{
  final int id;

  const RecommendationTvFetch(this.id);

  @override
  List<Object> get props => [id];
}
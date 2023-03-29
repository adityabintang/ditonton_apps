part of 'recom_bloc.dart';

abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object> get props => [];
}

class RecommendationLoading extends RecommendationState {}

class RecommendationEmpty extends RecommendationState {}

class RecommendationError extends RecommendationState{
  final String message;

  const RecommendationError(this.message);


  @override
  List<Object> get props => [message];
}

class RecommendationLoaded extends RecommendationState{
  final List<Movie> result;

  const RecommendationLoaded(this.result);

  @override
  List<Object> get props => [result];
}

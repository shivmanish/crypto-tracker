import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/trending_coin_entity.dart';

sealed class TrendingState extends Equatable {
  const TrendingState();

  @override
  List<Object?> get props => [];
}

final class TrendingInitial extends TrendingState {
  const TrendingInitial();
}

final class TrendingLoading extends TrendingState {
  const TrendingLoading();
}

final class TrendingLoaded extends TrendingState {
  const TrendingLoaded(this.coins);

  final List<TrendingCoinEntity> coins;

  @override
  List<Object?> get props => [coins];
}

final class TrendingError extends TrendingState {
  const TrendingError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

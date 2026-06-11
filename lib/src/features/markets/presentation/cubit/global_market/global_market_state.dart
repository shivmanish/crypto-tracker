import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/global_market_entity.dart';

sealed class GlobalMarketState extends Equatable {
  const GlobalMarketState();

  @override
  List<Object?> get props => [];
}

final class GlobalMarketInitial extends GlobalMarketState {
  const GlobalMarketInitial();
}

final class GlobalMarketLoading extends GlobalMarketState {
  const GlobalMarketLoading();
}

final class GlobalMarketLoaded extends GlobalMarketState {
  const GlobalMarketLoaded(this.market);

  final GlobalMarketEntity market;

  @override
  List<Object?> get props => [market];
}

final class GlobalMarketError extends GlobalMarketState {
  const GlobalMarketError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

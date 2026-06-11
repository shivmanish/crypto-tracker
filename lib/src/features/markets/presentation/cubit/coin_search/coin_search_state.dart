import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/coin_base_entity.dart';

sealed class CoinSearchState extends Equatable {
  const CoinSearchState();

  @override
  List<Object?> get props => [];
}

/// No active query (empty or below the min length) — the screen shows the
/// normal paginated list.
final class CoinSearchInactive extends CoinSearchState {
  const CoinSearchInactive();
}

final class CoinSearchLoading extends CoinSearchState {
  const CoinSearchLoading();
}

final class CoinSearchLoaded extends CoinSearchState {
  const CoinSearchLoaded({required this.query, required this.results});

  final String query;
  final List<CoinBaseEntity> results;

  @override
  List<Object?> get props => [query, results];
}

final class CoinSearchError extends CoinSearchState {
  const CoinSearchError({required this.query, required this.failure});

  final String query;
  final Failure failure;

  bool get isOffline => failure is NetworkFailure;

  @override
  List<Object?> get props => [query, failure];
}

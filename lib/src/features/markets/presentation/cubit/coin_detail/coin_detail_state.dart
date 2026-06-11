import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/coin_detail_entity.dart';

sealed class CoinDetailState extends Equatable {
  const CoinDetailState();

  @override
  List<Object?> get props => [];
}

final class CoinDetailInitial extends CoinDetailState {
  const CoinDetailInitial();
}

final class CoinDetailLoading extends CoinDetailState {
  const CoinDetailLoading();
}

final class CoinDetailLoaded extends CoinDetailState {
  const CoinDetailLoaded(this.detail);

  final CoinDetailEntity detail;

  @override
  List<Object?> get props => [detail];
}

final class CoinDetailError extends CoinDetailState {
  const CoinDetailError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

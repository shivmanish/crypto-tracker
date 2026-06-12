import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/coin_base_entity.dart';
import '../repository/markets_repository.dart';

class SearchCoinsUseCase
    extends UseCase<List<CoinBaseEntity>, SearchCoinsParams> {
  SearchCoinsUseCase(this._repository);

  final MarketsRepository _repository;

  @override
  Future<Either<Failure, List<CoinBaseEntity>>> call(SearchCoinsParams params) {
    return _repository.searchCoins(params);
  }
}

class SearchCoinsParams extends Equatable {
  const SearchCoinsParams(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

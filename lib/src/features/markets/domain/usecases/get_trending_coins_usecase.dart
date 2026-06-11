import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_router.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trending_coin_entity.dart';
import '../repository/markets_repository.dart';

class GetTrendingCoinsUseCase
    extends UseCase<List<TrendingCoinEntity>, TrendingParams> {
  GetTrendingCoinsUseCase(this._repository);

  final MarketsRepository _repository;

  @override
  Future<Either<Failure, List<TrendingCoinEntity>>> call(
    TrendingParams params,
  ) {
    return _repository.getTrending(params);
  }
}

/// Endpoint descriptor for `GET /search/trending`.
class TrendingParams extends APIRouter {
  TrendingParams();

  @override
  String get path => '/search/trending';
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_router.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/global_market_entity.dart';
import '../repository/markets_repository.dart';

class GetGlobalMarketUseCase
    extends UseCase<GlobalMarketEntity, GlobalMarketParams> {
  GetGlobalMarketUseCase(this._repository);

  final MarketsRepository _repository;

  @override
  Future<Either<Failure, GlobalMarketEntity>> call(GlobalMarketParams params) {
    return _repository.getGlobalMarket(params);
  }
}

class GlobalMarketParams extends APIRouter {
  GlobalMarketParams();

  @override
  String get path => '/global';
}

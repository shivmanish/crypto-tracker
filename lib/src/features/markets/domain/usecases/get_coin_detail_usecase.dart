import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_router.dart';
import '../../../../core/network/server_type.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/coin_detail_entity.dart';
import '../repository/markets_repository.dart';

class GetCoinDetailUseCase
    extends UseCase<CoinDetailEntity, CoinDetailParams> {
  GetCoinDetailUseCase(this._repository);

  final MarketsRepository _repository;

  @override
  Future<Either<Failure, CoinDetailEntity>> call(CoinDetailParams params) {
    return _repository.getCoinDetail(params);
  }
}

/// Endpoint descriptor for `GET /coins/{id}` with market data.
class CoinDetailParams extends APIRouter {
  CoinDetailParams(this.coinId);

  final String coinId;

  @override
  String get path => '/coins/$coinId';

  @override
  Map<String, dynamic> get queryParams => const {
        'localization': false,
        'tickers': false,
        'market_data': true,
        'community_data': false,
        'developer_data': false,
      };

  @override
  ServerType get serverType => ServerType.coinGecko;
}

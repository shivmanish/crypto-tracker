import 'package:dartz/dartz.dart';

import '../../../../core/cubit/paginated_list/paginated_list_params.dart';
import '../../../../core/cubit/paginated_list/paginated_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_router.dart';
import '../../../../core/network/server_type.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/coin_entity.dart';
import '../repository/markets_repository.dart';

class GetCoinsUseCase
    extends UseCase<PaginatedResponse<CoinEntity>, CoinsParams> {
  GetCoinsUseCase(this._repository);

  final MarketsRepository _repository;

  @override
  Future<Either<Failure, PaginatedResponse<CoinEntity>>> call(
    CoinsParams params,
  ) {
    return _repository.getCoins(params);
  }
}

class CoinsParams extends PaginatedListParams implements APIRouter {
  const CoinsParams({required super.page, required super.pageSize});

  @override
  String get path => '/coins/markets';

  @override
  Map<String, dynamic> get queryParams => {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': pageSize,
        'page': page,
      };

  @override
  Map<String, dynamic>? get headers => null;

  @override
  dynamic get body => null;

  @override
  ServerType get serverType => ServerType.coinGecko;
}

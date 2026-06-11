import 'package:dartz/dartz.dart';

import '../../../../core/cubit/paginated_list/paginated_response.dart';
import '../../../../core/error/failures.dart';
import '../entities/coin_base_entity.dart';
import '../entities/coin_detail_entity.dart';
import '../entities/coin_entity.dart';
import '../entities/global_market_entity.dart';
import '../entities/trending_coin_entity.dart';
import '../usecases/get_coin_detail_usecase.dart';
import '../usecases/get_coins_usecase.dart';
import '../usecases/get_global_market_usecase.dart';
import '../usecases/get_trending_coins_usecase.dart';
import '../usecases/search_coins_usecase.dart';

abstract class MarketsRepository {
  Future<Either<Failure, GlobalMarketEntity>> getGlobalMarket(
    GlobalMarketParams params,
  );

  Future<Either<Failure, List<TrendingCoinEntity>>> getTrending(
    TrendingParams params,
  );

  Future<Either<Failure, PaginatedResponse<CoinEntity>>> getCoins(
    CoinsParams params,
  );

  /// Free-text search (online only — surfaces a NetworkFailure when offline).
  Future<Either<Failure, List<CoinBaseEntity>>> searchCoins(
    SearchCoinsParams params,
  );

  Future<Either<Failure, CoinDetailEntity>> getCoinDetail(
    CoinDetailParams params,
  );

  // Favorites (locally persisted).
  Future<Either<Failure, Set<String>>> getFavoriteIds();

  Future<Either<Failure, void>> saveFavoriteIds(Set<String> ids);
}

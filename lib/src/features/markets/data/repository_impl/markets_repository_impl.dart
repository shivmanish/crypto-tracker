import 'package:dartz/dartz.dart';

import '../../../../core/cubit/paginated_list/paginated_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/repository_result_handler.dart';
import '../../domain/entities/coin_base_entity.dart';
import '../../domain/entities/coin_detail_entity.dart';
import '../../domain/entities/coin_entity.dart';
import '../../domain/entities/global_market_entity.dart';
import '../../domain/entities/trending_coin_entity.dart';
import '../../domain/repository/markets_repository.dart';
import '../../domain/usecases/get_coin_detail_usecase.dart';
import '../../domain/usecases/get_coins_usecase.dart';
import '../../domain/usecases/get_global_market_usecase.dart';
import '../../domain/usecases/get_trending_coins_usecase.dart';
import '../../domain/usecases/search_coins_usecase.dart';
import '../datasource/market_data_source.dart';
import '../models/coin_detail_model.dart';
import '../models/coin_model.dart';
import '../models/global_market_model.dart';
import '../models/trending_coin_model.dart';

class MarketsRepositoryImpl
    with RepositoryResultHandler
    implements MarketsRepository {
  MarketsRepositoryImpl({
    required this.remote,
    required this.local,
    required this.connectivity,
  });

  final MarketDataSource remote;
  final MarketLocalDataSource local;
  final ConnectivityService connectivity;

  @override
  Future<Either<Failure, GlobalMarketEntity>> getGlobalMarket(
    GlobalMarketParams params,
  ) {
    return result<GlobalMarketEntity>(() async {
      final online =
          await connectivity.currentStatus() == ConnectivityStatus.online;

      if (!online) return local.fetchGlobalMarket(params);

      try {
        final fresh = await remote.fetchGlobalMarket(params);
        await _cache(fresh);
        return fresh;
      } on NetworkException catch (e) {
        return _cachedOr(params, e);
      } on RateLimitException catch (e) {
        return _cachedOr(params, e);
      }
    });
  }

  @override
  Future<Either<Failure, List<TrendingCoinEntity>>> getTrending(
    TrendingParams params,
  ) {
    return result<List<TrendingCoinEntity>>(() async {
      final online =
          await connectivity.currentStatus() == ConnectivityStatus.online;

      if (!online) return local.fetchTrending(params);

      try {
        final fresh = await remote.fetchTrending(params);
        await _cacheTrending(fresh);
        return fresh;
      } on NetworkException catch (e) {
        return _cachedTrendingOr(params, e);
      } on RateLimitException catch (e) {
        return _cachedTrendingOr(params, e);
      }
    });
  }

  @override
  Future<Either<Failure, CoinDetailEntity>> getCoinDetail(
    CoinDetailParams params,
  ) {
    return result<CoinDetailEntity>(() async {
      final online =
          await connectivity.currentStatus() == ConnectivityStatus.online;

      if (!online) return local.fetchCoinDetail(params);

      try {
        final fresh = await remote.fetchCoinDetail(params);
        await _cacheDetail(fresh);
        return fresh;
      } on NetworkException {
        return local.fetchCoinDetail(params);
      } on RateLimitException {
        return local.fetchCoinDetail(params);
      }
    });
  }

  Future<void> _cacheDetail(CoinDetailModel detail) async {
    try {
      await local.cacheCoinDetail(detail);
    } catch (_) {}
  }

  @override
  Future<Either<Failure, List<CoinBaseEntity>>> searchCoins(
    SearchCoinsParams params,
  ) {
    return result<List<CoinBaseEntity>>(() async {
      final online =
          await connectivity.currentStatus() == ConnectivityStatus.online;
      if (!online) {
        throw NetworkException('Search needs an internet connection.');
      }
      return remote.searchCoins(params.query);
    });
  }

  @override
  Future<Either<Failure, Set<String>>> getFavoriteIds() =>
      localResult(() => local.getFavoriteIds());

  @override
  Future<Either<Failure, void>> saveFavoriteIds(Set<String> ids) =>
      localResult(() => local.saveFavoriteIds(ids));

  Future<void> _cache(GlobalMarketModel model) async {
    try {
      await local.cacheGlobalMarket(model);
    } catch (_) {}
  }

  @override
  Future<Either<Failure, PaginatedResponse<CoinEntity>>> getCoins(
    CoinsParams params,
  ) {
    return result<PaginatedResponse<CoinEntity>>(() async {
      final online =
          await connectivity.currentStatus() == ConnectivityStatus.online;

      if (!online) return _toPage(await local.fetchCoins(params), params);

      try {
        final fresh = await remote.fetchCoins(params);
        await _cacheCoins(fresh);
        return _toPage(fresh, params);
      } on NetworkException catch (e) {
        return _toPage(await _cachedCoinsOr(params, e), params);
      } on RateLimitException catch (e) {
        return _toPage(await _cachedCoinsOr(params, e), params);
      }
    });
  }

  PaginatedResponse<CoinEntity> _toPage(
    List<CoinModel> items,
    CoinsParams params,
  ) {
    final nextPage = items.length < params.pageSize ? null : params.page + 1;
    return PaginatedResponse(items: items, nextPage: nextPage);
  }

  Future<void> _cacheCoins(List<CoinModel> coins) async {
    try {
      await local.cacheCoins(coins);
    } catch (_) {}
  }

  Future<List<CoinModel>> _cachedCoinsOr(
    CoinsParams params,
    Object original,
  ) async {
    try {
      return await local.fetchCoins(params);
    } on CacheException {
      throw original;
    }
  }

  Future<void> _cacheTrending(List<TrendingCoinModel> coins) async {
    try {
      await local.cacheTrending(coins);
    } catch (_) {}
  }

  Future<List<TrendingCoinModel>> _cachedTrendingOr(
    TrendingParams params,
    Object original,
  ) async {
    try {
      return await local.fetchTrending(params);
    } on CacheException {
      throw original;
    }
  }

  Future<GlobalMarketModel> _cachedOr(
    GlobalMarketParams params,
    Object original,
  ) async {
    try {
      return await local.fetchGlobalMarket(params);
    } on CacheException {
      throw original;
    }
  }
}

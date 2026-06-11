import '../../domain/usecases/get_coin_detail_usecase.dart';
import '../../domain/usecases/get_coins_usecase.dart';
import '../../domain/usecases/get_global_market_usecase.dart';
import '../../domain/usecases/get_trending_coins_usecase.dart';
import '../models/coin_detail_model.dart';
import '../models/coin_model.dart';
import '../models/global_market_model.dart';
import '../models/search_coin_model.dart';
import '../models/trending_coin_model.dart';

/// Read surface shared by the remote (API) and local (cache) sources — same
/// methods, same return types; only the backing resource differs. The
/// repository swaps between implementations based on connectivity.
abstract class MarketDataSource {
  Future<GlobalMarketModel> fetchGlobalMarket(GlobalMarketParams route);

  Future<List<TrendingCoinModel>> fetchTrending(TrendingParams route);

  /// One page of coins (the local source paginates its cache by rank).
  Future<List<CoinModel>> fetchCoins(CoinsParams route);

  Future<CoinDetailModel> fetchCoinDetail(CoinDetailParams route);

  /// Free-text search. Remote-only; the local source throws (no offline search).
  Future<List<SearchCoinModel>> searchCoins(String query);
}

/// The local source also writes the cache + persists favorites, on top of the
/// shared reads.
abstract class MarketLocalDataSource extends MarketDataSource {
  Future<void> cacheGlobalMarket(GlobalMarketModel model);

  Future<void> cacheTrending(List<TrendingCoinModel> coins);

  Future<void> cacheCoins(List<CoinModel> coins);

  /// Enrich a coin's row with full detail (set when a detail is opened online).
  Future<void> cacheCoinDetail(CoinDetailModel detail);

  // Favorites — persisted as a small id set in shared_preferences.
  Future<Set<String>> getFavoriteIds();

  Future<void> saveFavoriteIds(Set<String> ids);
}

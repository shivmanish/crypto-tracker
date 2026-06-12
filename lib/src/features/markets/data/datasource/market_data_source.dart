import '../../domain/usecases/get_coin_detail_usecase.dart';
import '../../domain/usecases/get_coins_usecase.dart';
import '../../domain/usecases/get_global_market_usecase.dart';
import '../../domain/usecases/get_trending_coins_usecase.dart';
import '../models/coin_detail_model.dart';
import '../models/coin_model.dart';
import '../models/global_market_model.dart';
import '../models/search_coin_model.dart';
import '../models/trending_coin_model.dart';

abstract class MarketDataSource {
  Future<GlobalMarketModel> fetchGlobalMarket(GlobalMarketParams route);

  Future<List<TrendingCoinModel>> fetchTrending(TrendingParams route);

  Future<List<CoinModel>> fetchCoins(CoinsParams route);

  Future<CoinDetailModel> fetchCoinDetail(CoinDetailParams route);

  Future<List<SearchCoinModel>> searchCoins(String query);
}

abstract class MarketLocalDataSource extends MarketDataSource {
  Future<void> cacheGlobalMarket(GlobalMarketModel model);

  Future<void> cacheTrending(List<TrendingCoinModel> coins);

  Future<void> cacheCoins(List<CoinModel> coins);

  Future<void> cacheCoinDetail(CoinDetailModel detail);

  Future<Set<String>> getFavoriteIds();

  Future<void> saveFavoriteIds(Set<String> ids);
}

import 'package:crypto_tracker/src/core/network/api_client.dart';
import 'package:crypto_tracker/src/core/services/connectivity_service.dart';
import 'package:crypto_tracker/src/core/services/local_storage_service.dart';
import 'package:crypto_tracker/src/core/usecases/usecase.dart';
import 'package:crypto_tracker/src/features/markets/data/datasource/market_data_source.dart';
import 'package:crypto_tracker/src/features/markets/data/models/coin_detail_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/coin_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/global_market_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/trending_coin_model.dart';
import 'package:crypto_tracker/src/features/markets/domain/repository/markets_repository.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coin_detail_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coins_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_favorite_ids_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_global_market_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_trending_coins_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/save_favorites_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/search_coins_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockMarketsRepository extends Mock implements MarketsRepository {}

class MockMarketDataSource extends Mock implements MarketDataSource {}

class MockMarketLocalDataSource extends Mock
    implements MarketLocalDataSource {}

class MockConnectivityService extends Mock implements ConnectivityService {}

class MockApiClient extends Mock implements ApiClient {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockGetCoinsUseCase extends Mock implements GetCoinsUseCase {}

class MockGetGlobalMarketUseCase extends Mock
    implements GetGlobalMarketUseCase {}

class MockGetTrendingCoinsUseCase extends Mock
    implements GetTrendingCoinsUseCase {}

class MockGetCoinDetailUseCase extends Mock implements GetCoinDetailUseCase {}

class MockSearchCoinsUseCase extends Mock implements SearchCoinsUseCase {}

class MockGetFavoriteIdsUseCase extends Mock
    implements GetFavoriteIdsUseCase {}

class MockSaveFavoritesUseCase extends Mock implements SaveFavoritesUseCase {}

/// Registers fallback values for every param type passed to mocktail `any()`.
/// Call once from `setUpAll`.
void registerFallbacks() {
  registerFallbackValue(const CoinsParams(page: 1, pageSize: 20));
  registerFallbackValue(GlobalMarketParams());
  registerFallbackValue(TrendingParams());
  registerFallbackValue(CoinDetailParams('bitcoin'));
  registerFallbackValue(const SearchCoinsParams('btc'));
  registerFallbackValue(const NoParams());
  registerFallbackValue(<String>{});
  registerFallbackValue(<CoinModel>[]);
  registerFallbackValue(<TrendingCoinModel>[]);
  registerFallbackValue(
    const GlobalMarketModel(
      totalMarketCapUsd: 0,
      totalVolumeUsd: 0,
      marketCapChangePercentage24h: 0,
    ),
  );
  registerFallbackValue(
    const CoinDetailModel(
      id: '',
      symbol: '',
      name: '',
      image: '',
      marketCapRank: 0,
      description: '',
      currentPrice: 0,
      priceChangePercentage24h: 0,
      marketCap: 0,
      totalVolume: 0,
      ath: 0,
      athChangePercentage: 0,
      atl: 0,
      atlChangePercentage: 0,
      circulatingSupply: 0,
      maxSupply: null,
    ),
  );
}

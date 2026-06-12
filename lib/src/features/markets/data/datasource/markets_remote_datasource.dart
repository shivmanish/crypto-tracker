import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_router.dart';
import '../../../../core/network/codecs.dart';
import '../../domain/usecases/get_coin_detail_usecase.dart';
import '../../domain/usecases/get_coins_usecase.dart';
import '../../domain/usecases/get_global_market_usecase.dart';
import '../../domain/usecases/get_trending_coins_usecase.dart';
import '../models/coin_detail_model.dart';
import '../models/coin_model.dart';
import '../models/global_market_model.dart';
import '../models/search_coin_model.dart';
import '../models/trending_coin_model.dart';
import 'market_data_source.dart';

class MarketsRemoteDataSourceImpl implements MarketDataSource {
  MarketsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<GlobalMarketModel> fetchGlobalMarket(GlobalMarketParams route) async {
    final response = await _client.getRequest(route);
    final data = response.data;
    if (data is! JsonMap) {
      throw ServerException('GET ${route.path} returned an unexpected body.');
    }
    return GlobalMarketModel.fromApi(data);
  }

  @override
  Future<List<TrendingCoinModel>> fetchTrending(TrendingParams route) async {
    final response = await _client.getRequest(route);
    final data = response.data;
    if (data is! JsonMap || data['coins'] is! List) {
      throw ServerException('GET ${route.path} returned an unexpected body.');
    }
    return (data['coins'] as List)
        .whereType<Map<String, dynamic>>()
        .map((e) => (e['item'] as Map?)?.cast<String, dynamic>())
        .whereType<JsonMap>()
        .map(TrendingCoinModel.fromApi)
        .toList(growable: false);
  }

  @override
  Future<List<CoinModel>> fetchCoins(CoinsParams route) async {
    final response = await _client.getRequest(route);
    final data = response.data;
    if (data is! List) {
      throw ServerException('GET ${route.path} did not return a list.');
    }
    return data
        .whereType<JsonMap>()
        .map(CoinModel.fromApi)
        .toList(growable: false);
  }

  @override
  Future<CoinDetailModel> fetchCoinDetail(CoinDetailParams route) async {
    final response = await _client.getRequest(route);
    final data = response.data;
    if (data is! JsonMap) {
      throw ServerException('GET ${route.path} returned an unexpected body.');
    }
    return CoinDetailModel.fromApi(data);
  }

  @override
  Future<List<SearchCoinModel>> searchCoins(String query) async {
    final response = await _client.getRequest(_SearchRoute(query));
    final data = response.data;
    if (data is! JsonMap || data['coins'] is! List) {
      throw ServerException('GET /search returned an unexpected body.');
    }
    return (data['coins'] as List)
        .whereType<JsonMap>()
        .map(SearchCoinModel.fromApi)
        .toList(growable: false);
  }
}

class _SearchRoute extends APIRouter {
  _SearchRoute(this.query);

  final String query;

  @override
  String get path => '/search';

  @override
  Map<String, dynamic> get queryParams => {'query': query};
}

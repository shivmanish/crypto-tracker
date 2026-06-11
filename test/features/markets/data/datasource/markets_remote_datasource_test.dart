import 'package:crypto_tracker/src/core/error/exceptions.dart';
import 'package:crypto_tracker/src/features/markets/data/datasource/markets_remote_datasource.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coin_detail_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coins_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_global_market_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_trending_coins_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockApiClient client;
  late MarketsRemoteDataSourceImpl source;

  setUpAll(registerFallbacks);

  setUp(() {
    client = MockApiClient();
    source = MarketsRemoteDataSourceImpl(client);
  });

  Response<dynamic> ok(dynamic data) =>
      Response(requestOptions: RequestOptions(path: ''), data: data);

  void stub(dynamic data) {
    when(() => client.getRequest(any())).thenAnswer((_) async => ok(data));
  }

  group('fetchCoins', () {
    test('parses a list of coins', () async {
      stub([coinMarketsJson(id: 'bitcoin'), coinMarketsJson(id: 'ethereum')]);
      final coins = await source.fetchCoins(
        const CoinsParams(page: 1, pageSize: 20),
      );
      expect(coins, hasLength(2));
      expect(coins.first.id, 'bitcoin');
    });

    test('throws ServerException when the body is not a list', () async {
      stub({'unexpected': true});
      expect(
        () => source.fetchCoins(const CoinsParams(page: 1, pageSize: 20)),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('fetchGlobalMarket', () {
    test('parses the global snapshot', () async {
      stub(globalJson());
      final m = await source.fetchGlobalMarket(GlobalMarketParams());
      expect(m.totalMarketCapUsd, 2440000000000.0);
    });

    test('throws ServerException on a non-map body', () async {
      stub(<dynamic>[]);
      expect(
        () => source.fetchGlobalMarket(GlobalMarketParams()),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('fetchTrending', () {
    test('unwraps coins[].item', () async {
      stub(trendingJson());
      final coins = await source.fetchTrending(TrendingParams());
      expect(coins, hasLength(1));
      expect(coins.first.id, 'bonk');
    });

    test('throws ServerException when coins is missing', () async {
      stub({'no_coins': true});
      expect(
        () => source.fetchTrending(TrendingParams()),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('fetchCoinDetail', () {
    test('parses comprehensive detail', () async {
      stub(coinDetailJson());
      final d = await source.fetchCoinDetail(CoinDetailParams('ethereum'));
      expect(d.currentPrice, 2095.85);
      expect(d.isComplete, isTrue);
    });
  });

  group('searchCoins', () {
    test('maps identity-only results', () async {
      stub(searchJson());
      final results = await source.searchCoins('bit');
      expect(results.single.id, 'bitcoin');
    });

    test('throws ServerException on an unexpected body', () async {
      stub({'coins': 'not-a-list'});
      expect(
        () => source.searchCoins('bit'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}

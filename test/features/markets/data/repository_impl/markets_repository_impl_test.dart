import 'package:crypto_tracker/src/core/error/exceptions.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/core/services/connectivity_service.dart';
import 'package:crypto_tracker/src/features/markets/data/repository_impl/markets_repository_impl.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coin_detail_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coins_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_global_market_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_trending_coins_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/search_coins_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockMarketDataSource remote;
  late MockMarketLocalDataSource local;
  late MockConnectivityService connectivity;
  late MarketsRepositoryImpl repo;

  setUpAll(registerFallbacks);

  setUp(() {
    remote = MockMarketDataSource();
    local = MockMarketLocalDataSource();
    connectivity = MockConnectivityService();
    repo = MarketsRepositoryImpl(
      remote: remote,
      local: local,
      connectivity: connectivity,
    );
  });

  void goOnline() => when(() => connectivity.currentStatus())
      .thenAnswer((_) async => ConnectivityStatus.online);
  void goOffline() => when(() => connectivity.currentStatus())
      .thenAnswer((_) async => ConnectivityStatus.offline);

  group('getCoins', () {
    const params = CoinsParams(page: 1, pageSize: 2);

    test('online → fetches remote, caches, derives hasMore from page fullness',
        () async {
      goOnline();
      when(() => remote.fetchCoins(any()))
          .thenAnswer((_) async => [coinModel(id: 'a'), coinModel(id: 'b')]);
      when(() => local.cacheCoins(any())).thenAnswer((_) async {});

      final result = await repo.getCoins(params);

      expect(result.isRight(), isTrue);
      final page = result.getOrElse(() => throw 'left');
      expect(page.items, hasLength(2));
      expect(page.nextPage, 2, reason: 'full page implies more');
      verify(() => local.cacheCoins(any())).called(1);
    });

    test('online → a non-full page yields nextPage = null', () async {
      goOnline();
      when(() => remote.fetchCoins(any()))
          .thenAnswer((_) async => [coinModel(id: 'a')]);
      when(() => local.cacheCoins(any())).thenAnswer((_) async {});

      final page = (await repo.getCoins(params)).getOrElse(() => throw 'left');
      expect(page.nextPage, isNull);
    });

    test('offline → reads from the local cache, no remote call', () async {
      goOffline();
      when(() => local.fetchCoins(any()))
          .thenAnswer((_) async => [coinModel(id: 'cached')]);

      final result = await repo.getCoins(params);

      expect(result.isRight(), isTrue);
      verifyNever(() => remote.fetchCoins(any()));
    });

    test('online but network throws → falls back to cache', () async {
      goOnline();
      when(() => remote.fetchCoins(any())).thenThrow(NetworkException());
      when(() => local.fetchCoins(any()))
          .thenAnswer((_) async => [coinModel(id: 'cached')]);

      final result = await repo.getCoins(params);
      expect(result.isRight(), isTrue);
    });

    test('online, network throws AND no cache → surfaces NetworkFailure',
        () async {
      goOnline();
      when(() => remote.fetchCoins(any())).thenThrow(NetworkException());
      when(() => local.fetchCoins(any())).thenThrow(CacheException());

      final result = await repo.getCoins(params);
      expect(result.isLeft(), isTrue);
      result.fold((f) => expect(f, isA<NetworkFailure>()), (_) {});
    });
  });

  group('getGlobalMarket', () {
    test('online → remote + cache', () async {
      goOnline();
      when(() => remote.fetchGlobalMarket(any()))
          .thenAnswer((_) async => globalModel());
      when(() => local.cacheGlobalMarket(any())).thenAnswer((_) async {});

      final result = await repo.getGlobalMarket(GlobalMarketParams());
      expect(result.isRight(), isTrue);
      verify(() => local.cacheGlobalMarket(any())).called(1);
    });

    test('offline → cache', () async {
      goOffline();
      when(() => local.fetchGlobalMarket(any()))
          .thenAnswer((_) async => globalModel());
      final result = await repo.getGlobalMarket(GlobalMarketParams());
      expect(result.isRight(), isTrue);
    });

    test('rate limited → falls back to cache', () async {
      goOnline();
      when(() => remote.fetchGlobalMarket(any()))
          .thenThrow(RateLimitException());
      when(() => local.fetchGlobalMarket(any()))
          .thenAnswer((_) async => globalModel());
      final result = await repo.getGlobalMarket(GlobalMarketParams());
      expect(result.isRight(), isTrue);
    });
  });

  group('getTrending', () {
    test('online → remote + cache', () async {
      goOnline();
      when(() => remote.fetchTrending(any()))
          .thenAnswer((_) async => [trendingModel()]);
      when(() => local.cacheTrending(any())).thenAnswer((_) async {});
      final result = await repo.getTrending(TrendingParams());
      expect(result.isRight(), isTrue);
      verify(() => local.cacheTrending(any())).called(1);
    });

    test('offline → cache', () async {
      goOffline();
      when(() => local.fetchTrending(any()))
          .thenAnswer((_) async => [trendingModel()]);
      final result = await repo.getTrending(TrendingParams());
      expect(result.isRight(), isTrue);
    });
  });

  group('getCoinDetail', () {
    final params = CoinDetailParams('ethereum');

    test('online → remote, then enriches the cache', () async {
      goOnline();
      when(() => remote.fetchCoinDetail(any()))
          .thenAnswer((_) async => coinDetailModel());
      when(() => local.cacheCoinDetail(any())).thenAnswer((_) async {});

      final result = await repo.getCoinDetail(params);
      expect(result.isRight(), isTrue);
      verify(() => local.cacheCoinDetail(any())).called(1);
    });

    test('online but cache write fails → still returns the good fetch',
        () async {
      goOnline();
      when(() => remote.fetchCoinDetail(any()))
          .thenAnswer((_) async => coinDetailModel());
      when(() => local.cacheCoinDetail(any())).thenThrow(CacheException());

      final result = await repo.getCoinDetail(params);
      expect(result.isRight(), isTrue);
    });

    test('offline → reads detail from the local cache', () async {
      goOffline();
      when(() => local.fetchCoinDetail(any()))
          .thenAnswer((_) async => coinDetailModel());
      final result = await repo.getCoinDetail(params);
      expect(result.isRight(), isTrue);
      verifyNever(() => remote.fetchCoinDetail(any()));
    });

    test('network error → falls back to local detail', () async {
      goOnline();
      when(() => remote.fetchCoinDetail(any())).thenThrow(NetworkException());
      when(() => local.fetchCoinDetail(any()))
          .thenAnswer((_) async => coinDetailModel());
      final result = await repo.getCoinDetail(params);
      expect(result.isRight(), isTrue);
    });
  });

  group('searchCoins', () {
    test('online → remote results', () async {
      goOnline();
      when(() => remote.searchCoins(any()))
          .thenAnswer((_) async => []);
      final result = await repo.searchCoins(const SearchCoinsParams('btc'));
      expect(result.isRight(), isTrue);
    });

    test('offline → NetworkFailure (no offline search)', () async {
      goOffline();
      final result = await repo.searchCoins(const SearchCoinsParams('btc'));
      result.fold((f) => expect(f, isA<NetworkFailure>()), (_) => fail('right'));
      verifyNever(() => remote.searchCoins(any()));
    });
  });

  group('favorites', () {
    test('getFavoriteIds delegates to local', () async {
      when(() => local.getFavoriteIds()).thenAnswer((_) async => {'btc'});
      final result = await repo.getFavoriteIds();
      expect(result.getOrElse(() => {}), {'btc'});
    });

    test('saveFavoriteIds delegates to local', () async {
      when(() => local.saveFavoriteIds(any())).thenAnswer((_) async {});
      final result = await repo.saveFavoriteIds({'btc'});
      expect(result.isRight(), isTrue);
      verify(() => local.saveFavoriteIds({'btc'})).called(1);
    });

    test('local read failure → CacheFailure', () async {
      when(() => local.getFavoriteIds()).thenThrow(CacheException());
      final result = await repo.getFavoriteIds();
      result.fold((f) => expect(f, isA<CacheFailure>()), (_) => fail('right'));
    });
  });
}

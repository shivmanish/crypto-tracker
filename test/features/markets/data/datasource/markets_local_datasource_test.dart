import 'dart:convert';

import 'package:crypto_tracker/src/core/database/app_database.dart';
import 'package:crypto_tracker/src/core/error/exceptions.dart';
import 'package:crypto_tracker/src/features/markets/data/datasource/markets_local_datasource.dart';
import 'package:crypto_tracker/src/features/markets/data/models/coin_detail_model.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coin_detail_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coins_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_trending_coins_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/db_test_setup.dart';
import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

CoinDetailModel detailWithRank(String id, int rank) => CoinDetailModel(
      id: id,
      symbol: 'SYM',
      name: 'Name',
      image: 'img',
      marketCapRank: rank,
      description: 'desc',
      currentPrice: 1,
      priceChangePercentage24h: 1,
      marketCap: 1,
      totalVolume: 1,
      ath: 1,
      athChangePercentage: 1,
      atl: 1,
      atlChangePercentage: 1,
      circulatingSupply: 1,
      maxSupply: 2,
    );

void main() {
  late AppDatabase db;
  late MockLocalStorageService storage;
  late MarketsLocalDataSourceImpl source;

  setUpAll(() {
    initFfi();
    registerFallbacks();
  });

  setUp(() {
    db = newInMemoryDb();
    storage = MockLocalStorageService();
    source = MarketsLocalDataSourceImpl(storage, db);
  });

  tearDown(() => db.close());

  group('coins cache', () {
    test('caches and paginates by rank', () async {
      await source.cacheCoins([
        coinModel(id: 'c2', rank: 2),
        coinModel(id: 'c1', rank: 1),
        coinModel(id: 'c3', rank: 3),
      ]);
      final page = await source.fetchCoins(
        const CoinsParams(page: 1, pageSize: 2),
      );
      expect(page.map((c) => c.id), ['c1', 'c2']);
    });

    test('second page offsets correctly', () async {
      await source.cacheCoins(
        List.generate(5, (i) => coinModel(id: 'c$i', rank: i + 1)),
      );
      final page2 = await source.fetchCoins(
        const CoinsParams(page: 2, pageSize: 2),
      );
      expect(page2.map((c) => c.id), ['c2', 'c3']);
    });

    test('throws CacheException when empty on first page', () {
      expect(
        () => source.fetchCoins(const CoinsParams(page: 1, pageSize: 20)),
        throwsA(isA<CacheException>()),
      );
    });

    test('caps the cache beyond rank 100 (but keeps detail-enriched rows)',
        () async {
      await source.cacheCoinDetail(detailWithRank('kept', 200));
      await source.cacheCoins([
        coinModel(id: 'low', rank: 5),
        coinModel(id: 'dropped', rank: 150),
      ]);

      final dbi = await db.database;
      final ids = (await dbi.query('coins'))
          .map((r) => r['id'] as String)
          .toSet();
      expect(ids, containsAll(['low', 'kept']));
      expect(ids, isNot(contains('dropped')));
    });
  });

  group('coin detail on the coins row', () {
    test('enriches the row → fetch returns a full (isComplete) detail',
        () async {
      await source.cacheCoinDetail(coinDetailModel(id: 'ethereum'));
      final d = await source.fetchCoinDetail(CoinDetailParams('ethereum'));
      expect(d.isComplete, isTrue);
      expect(d.ath, 4878.0);
      expect(d.description, contains('Ethereum'));
    });

    test('a list-only row returns a partial detail', () async {
      await source.cacheCoins([coinModel(id: 'bitcoin')]);
      final d = await source.fetchCoinDetail(CoinDetailParams('bitcoin'));
      expect(d.isComplete, isFalse);
      expect(d.currentPrice, 76764.0);
      expect(d.ath, 0);
    });

    test('throws NetworkException when the coin was never cached', () {
      expect(
        () => source.fetchCoinDetail(CoinDetailParams('unknown')),
        throwsA(isA<NetworkException>()),
      );
    });

    test('a later list refresh preserves saved detail (partial upsert)',
        () async {
      await source.cacheCoins([coinModel(id: 'ethereum', rank: 2)]);
      await source.cacheCoinDetail(coinDetailModel(id: 'ethereum'));
      await source.cacheCoins([coinModel(id: 'ethereum', rank: 2)]);

      final d = await source.fetchCoinDetail(CoinDetailParams('ethereum'));
      expect(d.isComplete, isTrue, reason: 'has_detail must survive a refresh');
      expect(d.description, isNotEmpty);
    });
  });

  group('trending cache', () {
    test('replaces the snapshot and reads it back', () async {
      await source.cacheTrending([trendingModel()]);
      final coins = await source.fetchTrending(TrendingParams());
      expect(coins.single.id, 'bonk');
    });

    test('throws CacheException when empty', () {
      expect(
        () => source.fetchTrending(TrendingParams()),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('favorites (KV storage)', () {
    test('getFavoriteIds returns empty set when nothing stored', () async {
      when(() => storage.readString(any())).thenAnswer((_) async => null);
      expect(await source.getFavoriteIds(), isEmpty);
    });

    test('getFavoriteIds decodes the stored JSON list', () async {
      when(() => storage.readString(any()))
          .thenAnswer((_) async => jsonEncode(['btc', 'eth']));
      expect(await source.getFavoriteIds(), {'btc', 'eth'});
    });

    test('saveFavoriteIds writes the encoded set', () async {
      when(() => storage.writeString(any(), any()))
          .thenAnswer((_) async {});
      await source.saveFavoriteIds({'btc'});
      verify(() => storage.writeString(any(), jsonEncode(['btc']))).called(1);
    });
  });

  group('search (offline)', () {
    test('throws NetworkException — search is online-only', () {
      expect(() => source.searchCoins('btc'),
          throwsA(isA<NetworkException>()));
    });
  });
}

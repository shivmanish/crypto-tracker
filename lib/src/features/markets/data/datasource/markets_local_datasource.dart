import 'dart:convert';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/dao.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/usecases/get_coin_detail_usecase.dart';
import '../../domain/usecases/get_coins_usecase.dart';
import '../../domain/usecases/get_global_market_usecase.dart';
import '../../domain/usecases/get_trending_coins_usecase.dart';
import '../models/coin_detail_model.dart';
import '../models/coin_model.dart';
import '../models/global_market_model.dart';
import '../models/search_coin_model.dart';
import '../models/trending_coin_model.dart';
import 'coin_db_mapper.dart';
import 'market_data_source.dart';
import 'trending_db_mapper.dart';

/// Local cache: KV (shared_preferences) for the single global object + the
/// favorites id-set; sqflite for the paginated coin list (capped to the top
/// [_maxCachedCoins]) and the trending snapshot. A coin's full detail is stored
/// on its own `coins` row (extra columns), filled when opened online.
class MarketsLocalDataSourceImpl implements MarketLocalDataSource {
  MarketsLocalDataSourceImpl(this._storage, this._db)
      : _coins = Dao<CoinModel>(_db, CoinDbMapper()),
        _trending = Dao<TrendingCoinModel>(_db, TrendingDbMapper());

  final LocalStorageService _storage;
  final AppDatabase _db;
  final Dao<CoinModel> _coins;
  final Dao<TrendingCoinModel> _trending;

  static const String _globalKey = 'crypto.global_market';
  static const String _favoritesKey = 'crypto.favorite_ids';

  /// Keep only the top-N coins cached (≈ first 5 pages of 20).
  static const int _maxCachedCoins = 100;

  // ---- Global market (KV) ----

  @override
  Future<GlobalMarketModel> fetchGlobalMarket(GlobalMarketParams route) async {
    final cached = await _storage.read(_globalKey, GlobalMarketModel.fromCache);
    if (cached == null) throw CacheException('No cached market data.');
    return cached;
  }

  @override
  Future<void> cacheGlobalMarket(GlobalMarketModel model) =>
      _storage.write(_globalKey, model, (m) => m.toCacheJson());

  // ---- Trending (sqflite snapshot, insertion order) ----

  @override
  Future<List<TrendingCoinModel>> fetchTrending(TrendingParams route) async {
    final cached = await _trending.getAll();
    if (cached.isEmpty) throw CacheException('No cached trending coins.');
    return cached;
  }

  @override
  Future<void> cacheTrending(List<TrendingCoinModel> coins) async {
    // replace the snapshot; getAll then returns them in insertion order
    await _trending.clear();
    await _trending.upsertAll(coins);
  }

  // ---- Coins (sqflite, paginated by rank) ----

  @override
  Future<List<CoinModel>> fetchCoins(CoinsParams route) async {
    final page = await _coins.getAll(
      orderBy: 'market_cap_rank ASC',
      limit: route.pageSize,
      offset: (route.page - 1) * route.pageSize,
    );
    if (page.isEmpty && route.page <= 1) {
      throw CacheException('No cached coins.');
    }
    return page;
  }

  @override
  Future<void> cacheCoins(List<CoinModel> coins) async {
    final db = await _db.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();
    for (final c in coins) {
      // Partial upsert: write only the list columns and DO NOT touch the
      // detail columns, so a list refresh never wipes a coin's saved detail.
      batch.rawInsert(
        '''
        INSERT INTO coins
          (id, symbol, name, image, current_price, market_cap,
           market_cap_rank, total_volume, price_change_percentage_24h, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(id) DO UPDATE SET
          symbol = excluded.symbol,
          name = excluded.name,
          image = excluded.image,
          current_price = excluded.current_price,
          market_cap = excluded.market_cap,
          market_cap_rank = excluded.market_cap_rank,
          total_volume = excluded.total_volume,
          price_change_percentage_24h = excluded.price_change_percentage_24h,
          updated_at = excluded.updated_at
        ''',
        [
          c.id, c.symbol, c.name, c.image, c.currentPrice, c.marketCap,
          c.marketCapRank, c.totalVolume, c.priceChangePercentage24h, now,
        ],
      );
    }
    await batch.commit(noResult: true);
    // Cap the list cache, but never drop a row that holds saved detail.
    await db.delete(
      'coins',
      where: 'market_cap_rank > ? AND has_detail = 0',
      whereArgs: [_maxCachedCoins],
    );
  }

  // ---- Coin detail (stored on the coin's own row) ----

  @override
  Future<CoinDetailModel> fetchCoinDetail(CoinDetailParams route) async {
    final db = await _db.database;
    final rows = await db.query(
      'coins',
      where: 'id = ?',
      whereArgs: [route.coinId],
      limit: 1,
    );
    if (rows.isEmpty) {
      // never listed/loaded → nothing to show offline
      throw NetworkException('Connect to the internet to view this coin.');
    }
    final row = rows.first;
    // Full detail if this coin was opened online before; else partial.
    if ((row['has_detail'] as int? ?? 0) == 1) {
      return CoinDetailModel.fromDb(row);
    }
    return CoinDetailModel.partialFromCoin(CoinModel.fromDb(row));
  }

  @override
  Future<void> cacheCoinDetail(CoinDetailModel detail) async {
    final db = await _db.database;
    // Enrich the coin's row with full detail (+ refresh market columns).
    await db.rawInsert(
      '''
      INSERT INTO coins
        (id, symbol, name, image, market_cap_rank, current_price, market_cap,
         total_volume, price_change_percentage_24h, description, ath,
         ath_change_percentage, atl, atl_change_percentage, circulating_supply,
         max_supply, has_detail, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?)
      ON CONFLICT(id) DO UPDATE SET
        symbol = excluded.symbol,
        name = excluded.name,
        image = excluded.image,
        market_cap_rank = excluded.market_cap_rank,
        current_price = excluded.current_price,
        market_cap = excluded.market_cap,
        total_volume = excluded.total_volume,
        price_change_percentage_24h = excluded.price_change_percentage_24h,
        description = excluded.description,
        ath = excluded.ath,
        ath_change_percentage = excluded.ath_change_percentage,
        atl = excluded.atl,
        atl_change_percentage = excluded.atl_change_percentage,
        circulating_supply = excluded.circulating_supply,
        max_supply = excluded.max_supply,
        has_detail = 1,
        updated_at = excluded.updated_at
      ''',
      [
        detail.id, detail.symbol, detail.name, detail.image,
        detail.marketCapRank, detail.currentPrice, detail.marketCap,
        detail.totalVolume, detail.priceChangePercentage24h, detail.description,
        detail.ath, detail.athChangePercentage, detail.atl,
        detail.atlChangePercentage, detail.circulatingSupply, detail.maxSupply,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );
  }

  // ---- Favorites (KV id set) ----

  @override
  Future<Set<String>> getFavoriteIds() async {
    final raw = await _storage.readString(_favoritesKey);
    if (raw == null) return {};
    return (jsonDecode(raw) as List).cast<String>().toSet();
  }

  @override
  Future<void> saveFavoriteIds(Set<String> ids) =>
      _storage.writeString(_favoritesKey, jsonEncode(ids.toList()));

  // ---- Search (not supported offline) ----

  @override
  Future<List<SearchCoinModel>> searchCoins(String query) {
    throw NetworkException('Search needs an internet connection.');
  }
}

import '../../../../core/network/codecs.dart';
import '../../domain/entities/coin_detail_entity.dart';
import 'coin_model.dart';

/// Decodes `/coins/{id}` (market_data is nested per-currency). Also builds a
/// partial detail from a cached list row for offline viewing.
class CoinDetailModel extends CoinDetailEntity {
  const CoinDetailModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.marketCapRank,
    required super.description,
    required super.currentPrice,
    required super.priceChangePercentage24h,
    required super.marketCap,
    required super.totalVolume,
    required super.ath,
    required super.athChangePercentage,
    required super.atl,
    required super.atlChangePercentage,
    required super.circulatingSupply,
    required super.maxSupply,
    super.isComplete,
  });

  /// Full detail read back from an enriched `coins` row (set when opened
  /// online). `has_detail = 1` guarantees the detail columns are present.
  factory CoinDetailModel.fromDb(Map<String, Object?> row) => CoinDetailModel(
        id: row['id'] as String,
        symbol: row['symbol'] as String,
        name: row['name'] as String,
        image: (row['image'] as String?) ?? '',
        marketCapRank: (row['market_cap_rank'] as int?) ?? 0,
        description: (row['description'] as String?) ?? '',
        currentPrice: _toDouble(row['current_price']),
        priceChangePercentage24h: _toDouble(row['price_change_percentage_24h']),
        marketCap: _toDouble(row['market_cap']),
        totalVolume: _toDouble(row['total_volume']),
        ath: _toDouble(row['ath']),
        athChangePercentage: _toDouble(row['ath_change_percentage']),
        atl: _toDouble(row['atl']),
        atlChangePercentage: _toDouble(row['atl_change_percentage']),
        circulatingSupply: _toDouble(row['circulating_supply']),
        maxSupply: (row['max_supply'] as num?)?.toDouble(),
      );

  /// Offline fallback — only the fields the cached list row carries are known.
  factory CoinDetailModel.partialFromCoin(CoinModel coin) => CoinDetailModel(
        id: coin.id,
        symbol: coin.symbol,
        name: coin.name,
        image: coin.image,
        marketCapRank: coin.marketCapRank,
        description: '',
        currentPrice: coin.currentPrice,
        priceChangePercentage24h: coin.priceChangePercentage24h,
        marketCap: coin.marketCap,
        totalVolume: coin.totalVolume,
        ath: 0,
        athChangePercentage: 0,
        atl: 0,
        atlChangePercentage: 0,
        circulatingSupply: 0,
        maxSupply: null,
        isComplete: false,
      );

  factory CoinDetailModel.fromApi(JsonMap json) {
    final market = (json['market_data'] as Map?)?.cast<String, dynamic>() ?? {};
    final image = (json['image'] as Map?)?.cast<String, dynamic>();
    final description = (json['description'] as Map?)?.cast<String, dynamic>();

    return CoinDetailModel(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      image: image?['large'] as String? ?? '',
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      description: (description?['en'] as String? ?? '').trim(),
      currentPrice: _usd(market, 'current_price'),
      priceChangePercentage24h:
          _toDouble(market['price_change_percentage_24h']),
      marketCap: _usd(market, 'market_cap'),
      totalVolume: _usd(market, 'total_volume'),
      ath: _usd(market, 'ath'),
      athChangePercentage: _usd(market, 'ath_change_percentage'),
      atl: _usd(market, 'atl'),
      atlChangePercentage: _usd(market, 'atl_change_percentage'),
      circulatingSupply: _toDouble(market['circulating_supply']),
      maxSupply: (market['max_supply'] as num?)?.toDouble(),
    );
  }

  /// Reads the `usd` entry from a per-currency map (or the value itself if the
  /// field is already a scalar).
  static double _usd(JsonMap market, String key) {
    final value = market[key];
    if (value is Map) return _toDouble(value['usd']);
    return _toDouble(value);
  }

  static double _toDouble(dynamic v) => (v as num?)?.toDouble() ?? 0;
}

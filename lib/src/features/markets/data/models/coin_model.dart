import '../../../../core/network/codecs.dart';
import '../../domain/entities/coin_entity.dart';

/// Decodes a coin from `/coins/markets` (API) and the sqflite `coins` row.
class CoinModel extends CoinEntity {
  const CoinModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.currentPrice,
    required super.marketCap,
    required super.marketCapRank,
    required super.totalVolume,
    required super.priceChangePercentage24h,
  });

  factory CoinModel.fromApi(JsonMap json) => CoinModel(
        id: json['id'] as String? ?? '',
        symbol: (json['symbol'] as String? ?? '').toUpperCase(),
        name: json['name'] as String? ?? '',
        image: json['image'] as String? ?? '',
        currentPrice: _toDouble(json['current_price']),
        marketCap: _toDouble(json['market_cap']),
        marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
        totalVolume: _toDouble(json['total_volume']),
        priceChangePercentage24h:
            _toDouble(json['price_change_percentage_24h']),
      );

  factory CoinModel.fromDb(Map<String, Object?> row) => CoinModel(
        id: row['id'] as String,
        symbol: row['symbol'] as String,
        name: row['name'] as String,
        image: (row['image'] as String?) ?? '',
        currentPrice: _toDouble(row['current_price']),
        marketCap: _toDouble(row['market_cap']),
        marketCapRank: (row['market_cap_rank'] as int?) ?? 0,
        totalVolume: _toDouble(row['total_volume']),
        priceChangePercentage24h: _toDouble(row['price_change_percentage_24h']),
      );

  Map<String, Object?> toDbMap() => {
        'id': id,
        'symbol': symbol,
        'name': name,
        'image': image,
        'current_price': currentPrice,
        'market_cap': marketCap,
        'market_cap_rank': marketCapRank,
        'total_volume': totalVolume,
        'price_change_percentage_24h': priceChangePercentage24h,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };

  static double _toDouble(dynamic v) => (v as num?)?.toDouble() ?? 0;
}

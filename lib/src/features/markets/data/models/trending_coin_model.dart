import '../../../../core/network/codecs.dart';
import '../../domain/entities/trending_coin_entity.dart';

class TrendingCoinModel extends TrendingCoinEntity {
  const TrendingCoinModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.rank,
    required super.thumb,
    required super.price,
    required super.priceChangePercentage24h,
  });

  factory TrendingCoinModel.fromApi(JsonMap item) {
    final data = (item['data'] as Map?)?.cast<String, dynamic>();
    final change =
        (data?['price_change_percentage_24h'] as Map?)?.cast<String, dynamic>();
    return TrendingCoinModel(
      id: item['id'] as String? ?? '',
      name: item['name'] as String? ?? '',
      symbol: (item['symbol'] as String? ?? '').toUpperCase(),
      rank: (item['market_cap_rank'] as num?)?.toInt() ?? 0,
      thumb: (item['large'] ?? item['small'] ?? item['thumb']) as String? ?? '',
      price: _toDouble(data?['price']),
      priceChangePercentage24h: _toDouble(change?['usd']),
    );
  }

  factory TrendingCoinModel.fromDb(Map<String, Object?> row) =>
      TrendingCoinModel(
        id: row['id'] as String,
        name: row['name'] as String,
        symbol: row['symbol'] as String,
        rank: (row['market_cap_rank'] as int?) ?? 0,
        thumb: (row['thumb'] as String?) ?? '',
        price: _toDouble(row['price']),
        priceChangePercentage24h: _toDouble(row['price_change_percentage_24h']),
      );

  Map<String, Object?> toDbMap() => {
        'id': id,
        'symbol': symbol,
        'name': name,
        'thumb': thumb,
        'price': price,
        'price_change_percentage_24h': priceChangePercentage24h,
        'market_cap_rank': rank,
      };

  static double _toDouble(dynamic v) => (v as num?)?.toDouble() ?? 0;
}

import '../../../../core/network/codecs.dart';
import '../../domain/entities/coin_base_entity.dart';

class SearchCoinModel extends CoinBaseEntity {
  const SearchCoinModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.marketCapRank,
  });

  factory SearchCoinModel.fromApi(JsonMap json) => SearchCoinModel(
        id: json['id'] as String? ?? '',
        symbol: (json['symbol'] as String? ?? '').toUpperCase(),
        name: json['name'] as String? ?? '',
        image: (json['large'] ?? json['thumb']) as String? ?? '',
        marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      );
}

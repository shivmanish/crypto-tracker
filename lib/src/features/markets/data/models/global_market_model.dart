import '../../../../core/network/codecs.dart';
import '../../domain/entities/global_market_entity.dart';

/// Decodes the `/global` API shape and the flat local-cache shape.
class GlobalMarketModel extends GlobalMarketEntity {
  const GlobalMarketModel({
    required super.totalMarketCapUsd,
    required super.totalVolumeUsd,
    required super.marketCapChangePercentage24h,
  });

  factory GlobalMarketModel.fromApi(JsonMap json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    final cap = (data['total_market_cap'] as Map?)?.cast<String, dynamic>();
    final vol = (data['total_volume'] as Map?)?.cast<String, dynamic>();
    return GlobalMarketModel(
      totalMarketCapUsd: _toDouble(cap?['usd']),
      totalVolumeUsd: _toDouble(vol?['usd']),
      marketCapChangePercentage24h:
          _toDouble(data['market_cap_change_percentage_24h_usd']),
    );
  }

  factory GlobalMarketModel.fromCache(JsonMap json) => GlobalMarketModel(
        totalMarketCapUsd: _toDouble(json['totalMarketCapUsd']),
        totalVolumeUsd: _toDouble(json['totalVolumeUsd']),
        marketCapChangePercentage24h:
            _toDouble(json['marketCapChangePercentage24h']),
      );

  JsonMap toCacheJson() => {
        'totalMarketCapUsd': totalMarketCapUsd,
        'totalVolumeUsd': totalVolumeUsd,
        'marketCapChangePercentage24h': marketCapChangePercentage24h,
      };

  static double _toDouble(dynamic v) => (v as num?)?.toDouble() ?? 0;
}

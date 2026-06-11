import 'package:equatable/equatable.dart';

/// Comprehensive coin info shown on the detail screen.
class CoinDetailEntity extends Equatable {
  const CoinDetailEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.marketCapRank,
    required this.description,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    required this.ath,
    required this.athChangePercentage,
    required this.atl,
    required this.atlChangePercentage,
    required this.circulatingSupply,
    required this.maxSupply,
    this.isComplete = true,
  });

  final String id;
  final String symbol;
  final String name;
  final String image;
  final int marketCapRank;
  final String description;

  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final double totalVolume;
  final double ath;
  final double athChangePercentage;
  final double atl;
  final double atlChangePercentage;
  final double circulatingSupply;

  /// Null when the coin has no hard cap (rendered as "∞ uncapped").
  final double? maxSupply;

  /// false = a partial detail built from the cached list row (offline) — only
  /// price/market-cap/volume are known; ath/atl/supply/description are absent.
  final bool isComplete;

  bool get isUncapped => maxSupply == null;

  @override
  List<Object?> get props => [id, currentPrice, marketCapRank];
}

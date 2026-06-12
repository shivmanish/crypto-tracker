import 'coin_base_entity.dart';

class CoinEntity extends CoinBaseEntity {
  const CoinEntity({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.marketCapRank,
    required this.currentPrice,
    required this.marketCap,
    required this.totalVolume,
    required this.priceChangePercentage24h,
  });

  final double currentPrice;
  final double marketCap;
  final double totalVolume;
  final double priceChangePercentage24h;

  @override
  List<Object?> get props => [
        ...super.props,
        currentPrice,
        marketCap,
        totalVolume,
        priceChangePercentage24h,
      ];
}

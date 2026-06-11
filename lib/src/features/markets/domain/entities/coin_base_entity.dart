import 'package:equatable/equatable.dart';

/// Coin identity shared by `/search` results and the markets list — the fields
/// both responses have in common. [CoinEntity] extends this with market data.
abstract class CoinBaseEntity extends Equatable {
  const CoinBaseEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.marketCapRank,
  });

  final String id;
  final String symbol;
  final String name;
  final String image;
  final int marketCapRank;

  @override
  List<Object?> get props => [id, symbol, name, image, marketCapRank];
}

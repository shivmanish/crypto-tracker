import 'package:equatable/equatable.dart';

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

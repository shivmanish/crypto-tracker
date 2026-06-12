import 'package:equatable/equatable.dart';

class TrendingCoinEntity extends Equatable {
  const TrendingCoinEntity({
    required this.id,
    required this.name,
    required this.symbol,
    required this.rank,
    required this.thumb,
    required this.price,
    required this.priceChangePercentage24h,
  });

  final String id;
  final String name;
  final String symbol;
  final int rank;
  final String thumb;
  final double price;
  final double priceChangePercentage24h;

  @override
  List<Object?> get props => [id, price, priceChangePercentage24h];
}

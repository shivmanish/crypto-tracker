import 'package:equatable/equatable.dart';

class GlobalMarketEntity extends Equatable {
  const GlobalMarketEntity({
    required this.totalMarketCapUsd,
    required this.totalVolumeUsd,
    required this.marketCapChangePercentage24h,
  });

  final double totalMarketCapUsd;
  final double totalVolumeUsd;
  final double marketCapChangePercentage24h;

  @override
  List<Object?> get props =>
      [totalMarketCapUsd, totalVolumeUsd, marketCapChangePercentage24h];
}

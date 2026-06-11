import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../presentation/atoms/coin_logo.dart';
import '../../../../presentation/atoms/percent_badge.dart';
import '../../domain/entities/trending_coin_entity.dart';

/// Single card in the horizontal trending row.
class TrendingCard extends StatelessWidget {
  const TrendingCard({super.key, required this.coin, this.onTap});

  final TrendingCoinEntity coin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final type = context.typography;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimens.trendingCardWidth,
        padding: const EdgeInsets.all(AppDimens.gap),
        decoration: BoxDecoration(
          color: palette.surfaceCard,
          borderRadius: BorderRadius.circular(AppDimens.radiusChip),
          border: Border.all(color: palette.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CoinLogo(url: coin.thumb, symbol: coin.symbol, size: 28),
                const SizedBox(width: AppDimens.gapSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.symbol,
                        style: type.coinName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        coin.name,
                        style: type.coinSymbol,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (coin.rank > 0)
                  Text('#${coin.rank}', style: type.coinSymbol),
              ],
            ),
            const SizedBox(height: AppDimens.gap),
            Row(
              children: [
                Expanded(
                  child: Text(
                    coin.price.asPlainPrice,
                    style: type.coinPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppDimens.gapSm),
                PercentBadge(value: coin.priceChangePercentage24h, compact: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

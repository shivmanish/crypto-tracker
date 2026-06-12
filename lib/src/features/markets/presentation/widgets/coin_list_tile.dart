import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../shared_widgets/atoms/coin_logo.dart';
import '../../../../shared_widgets/atoms/percent_badge.dart';
import '../../../../shared_widgets/atoms/shimmer_box.dart';
import '../../domain/entities/coin_entity.dart';
import 'coin_favorite_star.dart';

class CoinListTile extends StatelessWidget {
  const CoinListTile({super.key, required this.coin, this.onTap});

  final CoinEntity coin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final type = context.typography;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.gutter,
          vertical: AppDimens.gap,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  '${coin.marketCapRank}',
                  style: type.coinSymbol,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(width: AppDimens.gapSm),
              CoinLogo(url: coin.image, symbol: coin.symbol, size: 34),
              const SizedBox(width: AppDimens.gap),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: type.coinName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${coin.symbol} · ${coin.marketCap.asCompactUsd}',
                      style: type.coinSymbol,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.gapSm),
              Align(
                alignment: Alignment.bottomCenter,
                widthFactor: 1,
                child: CoinFavoriteStar(coinId: coin.id),
              ),
              const SizedBox(width: AppDimens.gap),
              SizedBox(
                width: 96,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      coin.currentPrice.asPrice,
                      style: type.coinPrice,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    PercentBadge(
                      value: coin.priceChangePercentage24h,
                      compact: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoinListTileSkeleton extends StatelessWidget {
  const CoinListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.gutter,
        vertical: AppDimens.gap,
      ),
      child: Row(
        children: [
          ShimmerBox.rect(width: 14, height: 12),
          SizedBox(width: AppDimens.gapSm),
          ShimmerBox.circle(size: 34),
          SizedBox(width: AppDimens.gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox.rect(width: 110, height: 13),
                SizedBox(height: 6),
                ShimmerBox.rect(width: 70, height: 11),
              ],
            ),
          ),
          SizedBox(width: AppDimens.gap),
          SizedBox(
            width: 96,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShimmerBox.rect(width: 70, height: 13),
                SizedBox(height: 6),
                ShimmerBox.rect(width: 44, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

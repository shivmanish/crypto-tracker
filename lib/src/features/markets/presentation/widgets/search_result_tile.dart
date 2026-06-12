import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared_widgets/atoms/coin_logo.dart';
import '../../domain/entities/coin_base_entity.dart';
import 'coin_favorite_star.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.coin, this.onTap});

  final CoinBaseEntity coin;
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
        child: Row(
          children: [
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
                    coin.symbol,
                    style: type.coinSymbol,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (coin.marketCapRank > 0) ...[
              Text('#${coin.marketCapRank}', style: type.coinSymbol),
              const SizedBox(width: AppDimens.gap),
            ],
            CoinFavoriteStar(coinId: coin.id),
          ],
        ),
      ),
    );
  }
}

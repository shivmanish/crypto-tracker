import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../shared_widgets/atoms/coin_logo.dart';
import '../../../../shared_widgets/atoms/percent_badge.dart';
import '../../domain/entities/coin_detail_entity.dart';
import 'detail_stat_card.dart';

class CoinDetailHeader extends StatelessWidget {
  const CoinDetailHeader({super.key, required this.detail});

  final CoinDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final type = context.typography;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CoinLogo(url: detail.image, symbol: detail.symbol, size: 46),
        const SizedBox(width: AppDimens.gap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(detail.name.toUpperCase(), style: type.label),
              const SizedBox(height: 4),
              Text(detail.currentPrice.asPrice, style: type.priceLarge),
              const SizedBox(height: 6),
              Row(
                children: [
                  PercentBadge(
                    value: detail.priceChangePercentage24h,
                    showArrow: true,
                  ),
                  const SizedBox(width: 6),
                  Text('24h', style: type.coinSymbol),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CoinDetailBody extends StatelessWidget {
  const CoinDetailBody({super.key, required this.detail});

  final CoinDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final type = context.typography;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.gutter,
        AppDimens.gap,
        AppDimens.gutter,
        AppDimens.gutter,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(context.translate.marketStats),
          const SizedBox(height: AppDimens.gap),
          _StatsGrid(detail: detail),
          if (detail.isComplete) ...[
            const SizedBox(height: AppDimens.gutter),
            _SectionLabel(context.translate.aboutCoin(detail.name)),
            const SizedBox(height: AppDimens.gap),
            if (detail.description.isNotEmpty)
              Text(detail.description, style: type.about),
          ] else ...[
            const SizedBox(height: AppDimens.gap),
            const _PartialOfflineNote(),
          ],
          const SizedBox(height: AppDimens.gutter),
          Text(context.translate.sourceCoinGecko, style: type.label),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.detail});

  final CoinDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final l = context.translate;
    final palette = context.palette;
    final symbol = detail.symbol;

    final maxSupply = detail.isUncapped
        ? l.uncapped
        : '${detail.maxSupply!.asCompact} $symbol';

    return Column(
      children: [
        _row(
          DetailStatCard(
            label: l.statMarketCap,
            value: detail.marketCap.asCompactUsd,
          ),
          DetailStatCard(
            label: l.statVolume24h,
            value: detail.totalVolume.asCompactUsd,
          ),
        ),
        if (detail.isComplete) ...[
          const SizedBox(height: AppDimens.gap),
          _row(
            DetailStatCard(
              label: l.statAllTimeHigh,
              value: detail.ath.asPrice,
              sub: detail.athChangePercentage.asSignedPercent,
              subColor: palette.changeColor(detail.athChangePercentage),
            ),
            DetailStatCard(
              label: l.statAllTimeLow,
              value: detail.atl.asPrice,
              sub: detail.atlChangePercentage.asSignedPercent,
              subColor: palette.changeColor(detail.atlChangePercentage),
            ),
          ),
          const SizedBox(height: AppDimens.gap),
          _row(
            DetailStatCard(
              label: l.statCirculatingSupply,
              value: '${detail.circulatingSupply.asCompact} $symbol',
            ),
            DetailStatCard(label: l.statMaxSupply, value: maxSupply),
          ),
        ],
      ],
    );
  }

  Widget _row(Widget left, Widget right) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          const SizedBox(width: AppDimens.gap),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _PartialOfflineNote extends StatelessWidget {
  const _PartialOfflineNote();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppDimens.gap),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
        border: Border.all(color: palette.divider),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, size: 18, color: palette.textMuted),
          const SizedBox(width: AppDimens.gapSm),
          Expanded(
            child: Text(
              context.translate.partialOfflineNote,
              style: context.typography.coinSymbol,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.typography.label);
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../presentation/atoms/shimmer_box.dart';
import '../../domain/entities/global_market_entity.dart';

/// The market-cap / 24h-volume summary card at the top of the Markets screen.
class GlobalMarketCard extends StatelessWidget {
  const GlobalMarketCard({super.key, required this.market});

  final GlobalMarketEntity market;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final type = context.typography;
    final change = market.marketCapChangePercentage24h;

    return _CardShell(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: _Cell(
                label: context.translate.marketCapShort,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        market.totalMarketCapUsd.asCompactUsd,
                        style: type.statValue,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      change.asSignedPercent,
                      style: type.percent.copyWith(
                        color: palette.changeColor(change),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(width: 24, thickness: 1, color: palette.divider),
            Expanded(
              flex: 2,
              child: _Cell(
                label: context.translate.vol24hShort,
                child: Text(
                  market.totalVolumeUsd.asCompactUsd,
                  style: type.statValue,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton with the same chrome and layout as the loaded card.
class GlobalMarketCardLoading extends StatelessWidget {
  const GlobalMarketCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              flex: 3,
              child: _SkeletonCell(labelWidth: 92, valueWidth: 130),
            ),
            VerticalDivider(
              width: 24,
              thickness: 1,
              color: context.palette.divider,
            ),
            const Expanded(
              flex: 2,
              child: _SkeletonCell(labelWidth: 60, valueWidth: 84),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonCell extends StatelessWidget {
  const _SkeletonCell({required this.labelWidth, required this.valueWidth});

  final double labelWidth;
  final double valueWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShimmerBox.rect(width: labelWidth, height: 12),
        const SizedBox(height: 14),
        ShimmerBox.rect(width: valueWidth, height: 26),
      ],
    );
  }
}

/// Error chrome with a retry affordance.
class GlobalMarketCardError extends StatelessWidget {
  const GlobalMarketCardError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final type = context.typography;
    return _CardShell(
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: type.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(context.translate.retry)),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      constraints: const BoxConstraints(minHeight: 84),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.gutter,
        vertical: AppDimens.gap,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: palette.divider),
      ),
      child: child,
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: context.typography.label),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../presentation/atoms/shimmer_box.dart';
import '../cubit/trending/trending_cubit.dart';
import '../cubit/trending/trending_state.dart';
import 'trending_card.dart';

/// "TRENDING · 24H" header + a horizontally scrolling row of trending coins,
/// with shimmer / error / empty states.
class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key, this.onCoinTap});

  final void Function(String coinId)? onCoinTap;

  static const double _listHeight = 104;

  @override
  Widget build(BuildContext context) {
    final type = context.typography;

    return BlocBuilder<TrendingCubit, TrendingState>(
      builder: (context, state) {
        final count = state is TrendingLoaded ? state.coins.length : 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
              child: Row(
                children: [
                  Text(context.translate.trendingLabel, style: type.label),
                  const Spacer(),
                  if (count > 0)
                    Text(context.translate.coinsCount(count), style: type.label),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.gapSm),
            SizedBox(height: _listHeight, child: _body(context, state)),
          ],
        );
      },
    );
  }

  Widget _body(BuildContext context, TrendingState state) {
    switch (state) {
      case TrendingLoaded(:final coins):
        if (coins.isEmpty) return const SizedBox.shrink();
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
          itemCount: coins.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppDimens.gapSm),
          itemBuilder: (_, i) => TrendingCard(
            coin: coins[i],
            onTap: () => onCoinTap?.call(coins[i].id),
          ),
        );
      case TrendingError(:final failure):
        return _Message(
          text: failure.message,
          onRetry: context.read<TrendingCubit>().load,
        );
      case TrendingInitial():
      case TrendingLoading():
        return _loadingRow();
    }
  }

  Widget _loadingRow() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(width: AppDimens.gapSm),
      itemBuilder: (_, _) => const _TrendingCardSkeleton(),
    );
  }
}

class _TrendingCardSkeleton extends StatelessWidget {
  const _TrendingCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
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
              ShimmerBox.circle(size: 28),
              const SizedBox(width: AppDimens.gapSm),
              const Expanded(child: ShimmerBox.rect(width: 60, height: 12)),
            ],
          ),
          const SizedBox(height: AppDimens.gap),
          const ShimmerBox.rect(width: 90, height: 18),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.onRetry});

  final String text;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
      child: Row(
        children: [
          Expanded(
            child: Text(text,
                style: context.typography.coinSymbol,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
          TextButton(onPressed: onRetry, child: Text(context.translate.retry)),
        ],
      ),
    );
  }
}

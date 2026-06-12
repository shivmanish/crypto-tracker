import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/cubit/paginated_list/paginated_list_state.dart';
import '../../../../core/cubit/paginated_list/paginated_list_view.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/coin_entity.dart';
import '../../domain/usecases/get_coins_usecase.dart';
import '../cubit/coins_list/coins_list_cubit.dart';
import 'coin_list_tile.dart';

class CoinListView
    extends PaginatedListView<CoinEntity, CoinsParams, CoinsListCubit> {
  const CoinListView({super.key, required super.cubit, this.onCoinTap})
      : super(listType: PaginatedListType.sliver);

  final void Function(String coinId)? onCoinTap;

  @override
  Widget listItemBuilder(BuildContext context, CoinEntity coin, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CoinListTile(coin: coin, onTap: () => onCoinTap?.call(coin.id)),
        Divider(height: 1, thickness: 1, color: context.palette.divider),
      ],
    );
  }

  @override
  Widget noItemFoundBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.gutter * 2),
      child: Center(
        child: Text(
          context.translate.emptyCoinsTitle,
          style: context.typography.coinSymbol,
        ),
      ),
    );
  }

  @override
  Widget initialStateWidget(BuildContext context) => _skeletonSliver();

  @override
  Widget listingStateWidget(BuildContext context) => _skeletonSliver();

  @override
  Widget listingErrorWidget(
    BuildContext context,
    PaginatedListState<CoinEntity> state,
  ) {
    final failure = (state as PaginatedListError<CoinEntity>).failure;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.gutter * 1.5),
        child: Column(
          children: [
            Text(failure.message,
                style: context.typography.body, textAlign: TextAlign.center),
            const SizedBox(height: AppDimens.gap),
            FilledButton(
              onPressed: cubit.reset,
              child: Text(context.translate.retry),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget loadingWidget(BuildContext context) => const CoinListTileSkeleton();

  @override
  Widget loadMoreErrorBuilder(
    BuildContext context,
    PaginatedListState<CoinEntity> state,
    VoidCallback onRetry,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.gutter),
      child: Center(
        child: TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(context.translate.retry),
        ),
      ),
    );
  }

  Widget _skeletonSliver() {
    return SliverToBoxAdapter(
      child: Column(
        children: List.generate(
          8,
          (_) => const CoinListTileSkeleton(),
          growable: false,
        ),
      ),
    );
  }
}

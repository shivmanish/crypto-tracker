import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../presentation/molecules/status_view.dart';
import '../cubit/coin_search/coin_search_cubit.dart';
import '../cubit/coin_search/coin_search_state.dart';
import 'coin_list_tile.dart';
import 'search_result_tile.dart';

/// Sliver that renders the search state: skeleton while loading, the result
/// rows, a "no results" empty state, or the offline/error state with retry.
class CoinSearchResults extends StatelessWidget {
  const CoinSearchResults({
    super.key,
    required this.state,
    required this.onCoinTap,
  });

  final CoinSearchState state;
  final void Function(String coinId) onCoinTap;

  @override
  Widget build(BuildContext context) {
    final l = context.translate;

    switch (state) {
      case CoinSearchInactive():
        return const SliverToBoxAdapter(child: SizedBox.shrink());

      case CoinSearchLoading():
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, _) => const CoinListTileSkeleton(),
            childCount: 6,
          ),
        );

      case CoinSearchError(:final isOffline, :final failure):
        return SliverFillRemaining(
          hasScrollBody: false,
          child: StatusView(
            icon: isOffline
                ? Icons.wifi_off_rounded
                : Icons.error_outline_rounded,
            title: isOffline ? l.offlineTitle : l.errorTitle,
            message: isOffline ? l.searchOfflineMessage : failure.message,
            onRetry: () => context.read<CoinSearchCubit>().retry(),
          ),
        );

      case CoinSearchLoaded(:final results, :final query):
        if (results.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: StatusView(
              icon: Icons.search_off_rounded,
              title: l.noResultsTitle,
              message: l.noResults(query),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final coin = results[i];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchResultTile(
                    coin: coin,
                    onTap: () => onCoinTap(coin.id),
                  ),
                  Divider(height: 1, thickness: 1, color: context.palette.divider),
                ],
              );
            },
            childCount: results.length,
          ),
        );
    }
  }
}

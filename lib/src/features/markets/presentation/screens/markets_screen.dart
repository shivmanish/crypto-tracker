import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared_widgets/atoms/pinned_header_delegate.dart';
import '../../../../shared_widgets/molecules/app_search_bar.dart';
import '../../../../shared_widgets/molecules/settings_menu.dart';
import '../cubit/coin_search/coin_search_cubit.dart';
import '../cubit/coin_search/coin_search_state.dart';
import '../cubit/coins_list/coins_list_cubit.dart';
import '../cubit/favorites/favorites_cubit.dart';
import '../cubit/favorites/favorites_state.dart';
import '../cubit/global_market/global_market_cubit.dart';
import '../cubit/global_market/global_market_state.dart';
import '../cubit/trending/trending_cubit.dart';
import '../widgets/coin_list_view.dart';
import '../widgets/coin_search_results.dart';
import '../widgets/global_market_card.dart';
import '../widgets/trending_section.dart';

@RoutePage()
class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GlobalMarketCubit(useCase: sl())..load()),
        BlocProvider(create: (_) => TrendingCubit(useCase: sl())..load()),
        BlocProvider(create: (_) => CoinsListCubit(useCase: sl())),
        BlocProvider(create: (_) => CoinSearchCubit(useCase: sl())),
      ],
      child: const _MarketsView(),
    );
  }
}

class _MarketsView extends StatelessWidget {
  const _MarketsView();

  @override
  Widget build(BuildContext context) {
    final global = context.read<GlobalMarketCubit>();
    final trending = context.read<TrendingCubit>();
    final coins = context.read<CoinsListCubit>();
    final search = context.read<CoinSearchCubit>();

    Future<void> refresh() =>
        Future.wait([global.load(), trending.load(), coins.reset()]);

    final bg = context.palette.bgBase;

    return Scaffold(
      body: BlocListener<FavoritesCubit, FavoritesState>(
        listenWhen: (prev, curr) =>
            curr.error != null && curr.error != prev.error,
        listener: (context, state) =>
            context.showSnack(state.error!.message, isError: true),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PinnedHeaderDelegate(
                    height: 70,
                    background: bg,
                    child: const _Header(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.gutter,
                    AppDimens.gap,
                    AppDimens.gutter,
                    AppDimens.gutter,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<GlobalMarketCubit, GlobalMarketState>(
                      builder: (context, state) => switch (state) {
                        GlobalMarketLoaded(:final market) => GlobalMarketCard(
                          market: market,
                        ),
                        GlobalMarketError(:final failure) =>
                          GlobalMarketCardError(
                            message: failure.message,
                            onRetry: global.load,
                          ),
                        _ => const GlobalMarketCardLoading(),
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: TrendingSection(
                    onCoinTap: (id) =>
                        context.router.push(CoinDetailRoute(coinId: id)),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PinnedHeaderDelegate(
                    height: 105,
                    background: bg,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimens.gutter,
                            AppDimens.gap,
                            AppDimens.gutter,
                            AppDimens.gapSm,
                          ),
                          child: AppSearchBar(
                            onChanged: (text) => search.search(text),
                            onClear: () => search.search(''),
                          ),
                        ),
                        const Spacer(),
                        const _ColumnHeader(),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(color: context.palette.divider),
                ),
                // Search active → results; otherwise the (preserved) list.
                BlocBuilder<CoinSearchCubit, CoinSearchState>(
                  builder: (context, searchState) {
                    if (searchState is CoinSearchInactive) {
                      return CoinListView(
                        cubit: coins,
                        onCoinTap: (id) =>
                            context.router.push(CoinDetailRoute(coinId: id)),
                      );
                    }
                    return CoinSearchResults(
                      state: searchState,
                      onCoinTap: (id) =>
                          context.router.push(CoinDetailRoute(coinId: id)),
                    );
                  },
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppDimens.gutter),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final type = context.typography;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.gutter,
        AppDimens.gap,
        AppDimens.gutter,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: palette.priceUp,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(context.translate.liveLabel, style: type.label),
                  ],
                ),
                const SizedBox(height: 4),
                Text(context.translate.marketsTitle, style: type.screenTitle),
              ],
            ),
          ),
          const OverflowMenuButton(),
        ],
      ),
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader();

  @override
  Widget build(BuildContext context) {
    final type = context.typography;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.gutter,
        0,
        AppDimens.gutter,
        AppDimens.gapSm,
      ),
      child: Row(
        children: [
          SizedBox(width: 22, child: Text('#', style: type.label)),
          const SizedBox(width: AppDimens.gapSm),
          Text(context.translate.columnAsset, style: type.label),
          const Spacer(),
          Text(context.translate.columnPrice, style: type.label),
        ],
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared_widgets/atoms/circle_action_button.dart';
import '../../../../shared_widgets/atoms/pinned_header_delegate.dart';
import '../../../../shared_widgets/molecules/status_view.dart';
import '../../domain/entities/coin_detail_entity.dart';
import '../cubit/coin_detail/coin_detail_cubit.dart';
import '../cubit/coin_detail/coin_detail_state.dart';
import '../cubit/favorites/favorites_cubit.dart';
import '../cubit/favorites/favorites_state.dart';
import '../widgets/coin_detail_content.dart';

@RoutePage()
class CoinDetailScreen extends StatelessWidget {
  const CoinDetailScreen({@PathParam('id') required this.coinId, super.key});

  final String coinId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoinDetailCubit(useCase: sl())..load(coinId),
      child: _CoinDetailView(coinId: coinId),
    );
  }
}

class _CoinDetailView extends StatelessWidget {
  const _CoinDetailView({required this.coinId});

  final String coinId;

  static const double _topBarHeight = 64;
  static const double _headerHeight = 124;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CoinDetailCubit>();
    final bg = context.palette.bgBase;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => cubit.load(coinId),
          child: BlocBuilder<CoinDetailCubit, CoinDetailState>(
            builder: (context, state) {
              final detail = state is CoinDetailLoaded ? state.detail : null;
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: PinnedHeaderDelegate(
                      height: _topBarHeight,
                      background: bg,
                      child: _TopBar(coinId: coinId, detail: detail),
                    ),
                  ),
                  ..._buildBody(context, state, detail, bg),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBody(
    BuildContext context,
    CoinDetailState state,
    CoinDetailEntity? detail,
    Color bg,
  ) {
    if (detail != null) {
      return [
        SliverPersistentHeader(
          pinned: true,
          delegate: PinnedHeaderDelegate(
            height: _headerHeight,
            background: bg,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [CoinDetailHeader(detail: detail)],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: CoinDetailBody(detail: detail)),
      ];
    }

    if (state is CoinDetailError) {
      final offline = state.failure is NetworkFailure;
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: StatusView(
            icon: offline
                ? Icons.wifi_off_rounded
                : Icons.error_outline_rounded,
            title: offline
                ? context.translate.offlineTitle
                : context.translate.errorTitle,
            message: offline
                ? context.translate.detailOfflineMessage
                : state.failure.message,
            onRetry: () => context.read<CoinDetailCubit>().load(coinId),
          ),
        ),
      ];
    }

    return const [
      SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    ];
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.coinId, this.detail});

  final String coinId;
  final CoinDetailEntity? detail;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final d = detail;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
      child: Row(
        children: [
          CircleActionButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onTap: () => context.router.maybePop(),
            child: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: Center(
              child: d == null
                  ? const SizedBox.shrink()
                  : Text(
                      '${d.symbol} · ${context.translate.rankLabel(d.marketCapRank)}',
                      style: context.typography.appBarTitle,
                    ),
            ),
          ),
          BlocSelector<FavoritesCubit, FavoritesState, bool>(
            selector: (s) => s.isFavorite(coinId),
            builder: (context, isFavorite) => CircleActionButton(
              tooltip: context.translate.favorite,
              onTap: () => context.read<FavoritesCubit>().toggle(coinId),
              child: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isFavorite ? palette.favorite : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

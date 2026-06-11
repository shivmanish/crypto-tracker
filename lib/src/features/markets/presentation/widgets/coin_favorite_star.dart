import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared_widgets/atoms/favorite_star_button.dart';
import '../cubit/favorites/favorites_cubit.dart';
import '../cubit/favorites/favorites_state.dart';

/// Favorite star bound to the app-level [FavoritesCubit]. Rebuilds only when
/// this coin's favorite state changes. Reused by the list and search rows.
class CoinFavoriteStar extends StatelessWidget {
  const CoinFavoriteStar({super.key, required this.coinId});

  final String coinId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoritesCubit, FavoritesState, bool>(
      selector: (state) => state.isFavorite(coinId),
      builder: (context, isFavorite) => FavoriteStarButton(
        isFavorite: isFavorite,
        onTap: () => context.read<FavoritesCubit>().toggle(coinId),
      ),
    );
  }
}

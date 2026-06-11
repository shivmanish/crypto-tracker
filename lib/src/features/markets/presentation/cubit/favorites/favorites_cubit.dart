// Private use-case field can't be a named initializing formal.
// ignore_for_file: prefer_initializing_formals
import '../../../../../core/cubit/base_cubit.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_favorite_ids_usecase.dart';
import '../../../domain/usecases/save_favorites_usecase.dart';
import 'favorites_state.dart';

/// Owns the in-memory favorite set and mirrors it to local storage. Toggles
/// optimistically (instant star) and reverts if persistence fails.
///
/// [load] runs through the base [useCase] (get); the save use case is held
/// separately and invoked from [toggle].
class FavoritesCubit
    extends BaseCubit<FavoritesState, Set<String>, NoParams> {
  FavoritesCubit({
    required GetFavoriteIdsUseCase getFavoriteIds,
    required SaveFavoritesUseCase saveFavorites,
  })  : _saveFavorites = saveFavorites,
        super(initialState: const FavoritesState(), useCase: getFavoriteIds);

  final SaveFavoritesUseCase _saveFavorites;

  Future<void> load() {
    return handleUseCase(
      const NoParams(),
      onFailure: (failure) => safeEmit(state.copyWith(error: failure)),
      onSuccess: (ids) => safeEmit(state.copyWith(ids: ids, clearError: true)),
    );
  }

  Future<void> toggle(String coinId) async {
    final wasFavorite = state.ids.contains(coinId);
    final updated = Set<String>.from(state.ids);
    if (wasFavorite) {
      updated.remove(coinId);
    } else {
      updated.add(coinId);
    }
    safeEmit(state.copyWith(ids: updated, clearError: true));

    final result = await _saveFavorites(updated);
    if (isClosed) return;
    result.fold(
      (failure) {
        // revert the optimistic change, surface the error
        final reverted = Set<String>.from(state.ids);
        if (wasFavorite) {
          reverted.add(coinId);
        } else {
          reverted.remove(coinId);
        }
        safeEmit(state.copyWith(ids: reverted, error: failure));
      },
      (_) {},
    );
  }
}

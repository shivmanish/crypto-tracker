import '../../../../../core/cubit/base_cubit.dart';
import '../../../domain/entities/coin_base_entity.dart';
import '../../../domain/usecases/search_coins_usecase.dart';
import 'coin_search_state.dart';

class CoinSearchCubit
    extends BaseCubit<CoinSearchState, List<CoinBaseEntity>, SearchCoinsParams> {
  CoinSearchCubit({required SearchCoinsUseCase super.useCase})
      : super(initialState: const CoinSearchInactive());

  /// Search starts at this many characters (debounce happens in the search bar).
  static const int minQueryLength = 3;

  /// The latest requested query — used to discard out-of-order responses.
  String _latestQuery = '';

  Future<void> search(String text) async {
    final query = text.trim();
    _latestQuery = query;

    if (query.length < minQueryLength) {
      safeEmit(const CoinSearchInactive());
      return;
    }

    safeEmit(const CoinSearchLoading());
    await handleUseCase(
      SearchCoinsParams(query),
      onFailure: (failure) {
        if (query != _latestQuery) return;
        safeEmit(CoinSearchError(query: query, failure: failure));
      },
      onSuccess: (results) {
        if (query != _latestQuery) return;
        safeEmit(CoinSearchLoaded(query: query, results: results));
      },
    );
  }

  /// Re-run the current query (offline/error retry).
  Future<void> retry() => search(_latestQuery);
}

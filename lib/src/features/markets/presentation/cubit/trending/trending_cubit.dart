import '../../../../../core/cubit/base_cubit.dart';
import '../../../domain/entities/trending_coin_entity.dart';
import '../../../domain/usecases/get_trending_coins_usecase.dart';
import 'trending_state.dart';

class TrendingCubit
    extends BaseCubit<TrendingState, List<TrendingCoinEntity>, TrendingParams> {
  TrendingCubit({required GetTrendingCoinsUseCase super.useCase})
      : super(initialState: const TrendingInitial());

  Future<void> load() async {
    safeEmit(const TrendingLoading());
    await handleUseCase(
      TrendingParams(),
      onFailure: (failure) => safeEmit(TrendingError(failure)),
      onSuccess: (coins) => safeEmit(TrendingLoaded(coins)),
    );
  }
}

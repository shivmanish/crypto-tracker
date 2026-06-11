import '../../../../../core/cubit/base_cubit.dart';
import '../../../domain/entities/global_market_entity.dart';
import '../../../domain/usecases/get_global_market_usecase.dart';
import 'global_market_state.dart';

class GlobalMarketCubit
    extends BaseCubit<GlobalMarketState, GlobalMarketEntity, GlobalMarketParams> {
  GlobalMarketCubit({required GetGlobalMarketUseCase super.useCase})
      : super(initialState: const GlobalMarketInitial());

  Future<void> load() async {
    safeEmit(const GlobalMarketLoading());
    await handleUseCase(
      GlobalMarketParams(),
      onFailure: (failure) => safeEmit(GlobalMarketError(failure)),
      onSuccess: (market) => safeEmit(GlobalMarketLoaded(market)),
    );
  }
}

import '../../../../../core/cubit/base_cubit.dart';
import '../../../domain/entities/coin_detail_entity.dart';
import '../../../domain/usecases/get_coin_detail_usecase.dart';
import 'coin_detail_state.dart';

class CoinDetailCubit
    extends BaseCubit<CoinDetailState, CoinDetailEntity, CoinDetailParams> {
  CoinDetailCubit({required GetCoinDetailUseCase super.useCase})
      : super(initialState: const CoinDetailInitial());

  Future<void> load(String coinId) async {
    safeEmit(const CoinDetailLoading());
    await handleUseCase(
      CoinDetailParams(coinId),
      onFailure: (failure) => safeEmit(CoinDetailError(failure)),
      onSuccess: (detail) => safeEmit(CoinDetailLoaded(detail)),
    );
  }
}

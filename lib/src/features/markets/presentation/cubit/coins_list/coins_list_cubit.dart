import '../../../../../core/cubit/paginated_list/paginated_list_cubit.dart';
import '../../../domain/entities/coin_entity.dart';
import '../../../domain/usecases/get_coins_usecase.dart';

/// Paginated markets list. All paging behavior comes from the generic base;
/// this only builds the per-page params.
class CoinsListCubit extends PaginatedListCubit<CoinEntity, CoinsParams> {
  CoinsListCubit({required GetCoinsUseCase super.useCase})
      : super(pageSize: 20);

  @override
  CoinsParams buildParams(int page) =>
      CoinsParams(page: page, pageSize: pageSize);
}

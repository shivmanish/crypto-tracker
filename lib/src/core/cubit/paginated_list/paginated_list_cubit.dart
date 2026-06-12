import '../base_cubit.dart';
import '../../usecases/usecase.dart';
import 'paginated_list_params.dart';
import 'paginated_list_state.dart';
import 'paginated_response.dart';

abstract class PaginatedListCubit<T, P extends PaginatedListParams>
    extends BaseCubit<PaginatedListState<T>, PaginatedResponse<T>, P> {
  PaginatedListCubit({
    required UseCase<PaginatedResponse<T>, P> super.useCase,
    this.pageSize = 20,
    this.initialPage = 1,
  }) : super(initialState: PaginatedListInitial<T>());

  final int pageSize;
  final int initialPage;

  final List<T> objects = [];

  bool hasMorePages = false;

  int _generation = 0;

  P buildParams(int page);

  Future<void> fetchPage({required int page}) async {
    if (state is PaginatedListLoading<T>) return;

    final generation = _generation;
    safeEmit(PaginatedListLoading<T>(isFirstFetch: objects.isEmpty));

    await handleUseCase(
      buildParams(page),
      onFailure: (failure) {
        if (generation != _generation) return;
        safeEmit(PaginatedListError<T>(failure: failure));
      },
      onSuccess: (response) {
        if (generation != _generation) return;
        objects.addAll(response.items);
        hasMorePages = response.nextPage != null;
        safeEmit(PaginatedListLoaded<T>(response: response));
      },
    );
  }

  Future<void> reset() async {
    _generation++;
    objects.clear();
    hasMorePages = false;
    safeEmit(PaginatedListInitial<T>());
    await fetchPage(page: initialPage);
  }
}

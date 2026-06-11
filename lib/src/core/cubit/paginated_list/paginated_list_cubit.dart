import '../base_cubit.dart';
import '../../usecases/usecase.dart';
import 'paginated_list_params.dart';
import 'paginated_list_state.dart';
import 'paginated_response.dart';

/// Generic forward-only paginated list cubit.
///
/// Owns the mutable [objects] list (the view reads it directly) and the
/// next-page cursor. Subclasses implement only [buildParams]; the configured
/// [UseCase] returns `PaginatedResponse<T>`.
abstract class PaginatedListCubit<T, P extends PaginatedListParams>
    extends BaseCubit<PaginatedListState<T>, PaginatedResponse<T>, P> {
  PaginatedListCubit({
    required UseCase<PaginatedResponse<T>, P> super.useCase,
    this.pageSize = 20,
    this.initialPage = 1,
  }) : super(initialState: PaginatedListInitial<T>());

  final int pageSize;
  final int initialPage;

  /// Accumulated items. Forward fetches append here.
  final List<T> objects = [];

  bool hasMorePages = false;

  /// Bumped on [reset] so a still-in-flight page can't append onto the
  /// freshly cleared list.
  int _generation = 0;

  /// Build params (page + filters/search) for [page].
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

  /// Clear everything and refetch from [initialPage] (pull-to-refresh / retry).
  /// Safe to call mid-load: the in-flight page is discarded.
  Future<void> reset() async {
    _generation++;
    objects.clear();
    hasMorePages = false;
    safeEmit(PaginatedListInitial<T>());
    await fetchPage(page: initialPage);
  }
}

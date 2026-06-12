import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'paginated_list_cubit.dart';
import 'paginated_list_params.dart';
import 'paginated_list_state.dart';

enum PaginatedListType {
  listView,

  sliver,
}

abstract class PaginatedListView<T, P extends PaginatedListParams,
    C extends PaginatedListCubit<T, P>> extends StatefulWidget {
  const PaginatedListView({
    super.key,
    required this.cubit,
    this.reverse = false,
    this.listType = PaginatedListType.listView,
    this.padding = EdgeInsets.zero,
  });

  final C cubit;
  final bool reverse;
  final PaginatedListType listType;
  final EdgeInsetsGeometry padding;

  Widget listItemBuilder(BuildContext context, T object, int index);

  Widget noItemFoundBuilder(BuildContext context);

  Widget listingErrorWidget(BuildContext context, PaginatedListState<T> state);

  void onListingError(BuildContext context, PaginatedListState<T> state) {}

  Widget initialStateWidget(BuildContext context) => loadingWidget(context);

  Widget listingStateWidget(BuildContext context) => loadingWidget(context);

  Widget loadingWidget(BuildContext context) =>
      const Center(child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ));

  Widget loadMoreErrorBuilder(
    BuildContext context,
    PaginatedListState<T> state,
    VoidCallback onRetry,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: IconButton(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ),
    );
  }

  @override
  State<PaginatedListView<T, P, C>> createState() =>
      _PaginatedListViewState<T, P, C>();
}

class _PaginatedListViewState<T, P extends PaginatedListParams,
    C extends PaginatedListCubit<T, P>>
    extends State<PaginatedListView<T, P, C>> {
  C get _cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    final state = _cubit.state;
    if (state is PaginatedListInitial<T> ||
        (state is PaginatedListError<T> && _cubit.objects.isEmpty)) {
      _cubit.fetchPage(page: _cubit.initialPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, PaginatedListState<T>>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is PaginatedListInitial<T>) {
          return widget.initialStateWidget(context);
        }
        if (state is PaginatedListLoading<T> && state.isFirstFetch) {
          return widget.listingStateWidget(context);
        }
        if (state is PaginatedListLoaded<T>) {
          _cubit.hasMorePages = state.response.nextPage != null;
        }
        if (state is PaginatedListError<T> && _cubit.objects.isEmpty) {
          widget.onListingError(context, state);
          return widget.listingErrorWidget(context, state);
        }
        return _buildList(context);
      },
    );
  }

  Widget _buildList(BuildContext context) {
    final objects = _cubit.objects;
    final itemCount = _cubit.hasMorePages
        ? objects.length + 1
        : objects.isNotEmpty
            ? objects.length
            : 1;

    if (widget.listType == PaginatedListType.sliver) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(_itemBuilder, childCount: itemCount),
      );
    }

    return ListView.builder(
      reverse: widget.reverse,
      padding: widget.padding,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final objects = _cubit.objects;

    if (objects.isEmpty) return widget.noItemFoundBuilder(context);

    if (index < objects.length) {
      return widget.listItemBuilder(context, objects[index], index);
    }

    final state = _cubit.state;

    if (state is PaginatedListError<T>) {
      return widget.loadMoreErrorBuilder(context, state, _loadNextPage);
    }

    if (state is! PaginatedListLoading) {
      final page = _nextPageNumber();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _cubit.fetchPage(page: page);
      });
    }
    return widget.loadingWidget(context);
  }

  int _nextPageNumber() {
    final state = _cubit.state;
    if (state is PaginatedListLoaded<T> && state.response.nextPage != null) {
      return state.response.nextPage!;
    }
    return (_cubit.objects.length / _cubit.pageSize).ceil() + 1;
  }

  void _loadNextPage() => _cubit.fetchPage(page: _nextPageNumber());
}

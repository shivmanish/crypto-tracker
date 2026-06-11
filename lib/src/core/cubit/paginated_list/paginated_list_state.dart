import 'package:equatable/equatable.dart';

import '../../error/failures.dart';
import 'paginated_response.dart';

/// Minimal state signals. The item list itself lives on the cubit
/// (`cubit.objects`); the view reads it directly while rendering.
sealed class PaginatedListState<T> extends Equatable {
  const PaginatedListState();

  @override
  List<Object?> get props => [];
}

final class PaginatedListInitial<T> extends PaginatedListState<T> {
  const PaginatedListInitial();
}

final class PaginatedListLoading<T> extends PaginatedListState<T> {
  const PaginatedListLoading({required this.isFirstFetch});

  /// true = first page (full-screen loader), false = tail (footer loader).
  final bool isFirstFetch;

  @override
  List<Object?> get props => [isFirstFetch];
}

final class PaginatedListLoaded<T> extends PaginatedListState<T> {
  const PaginatedListLoaded({required this.response});

  final PaginatedResponse<T> response;

  @override
  List<Object?> get props => [response];
}

final class PaginatedListError<T> extends PaginatedListState<T> {
  const PaginatedListError({required this.failure});

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

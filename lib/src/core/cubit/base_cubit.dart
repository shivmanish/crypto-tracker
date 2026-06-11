import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../error/failures.dart';
import '../usecases/usecase.dart';

/// Core cubit. Wraps an optional [UseCase] and adds:
/// - [safeEmit]: no-op after close (avoids "emit after close" crashes).
/// - [handleUseCase]: runs the use case and folds the Either into callbacks.
///
/// Generics: S = state, T = use-case result, P = use-case params.
/// Cubits with no use case pass `useCase: null` and ignore T/P.
abstract class BaseCubit<S, T, P> extends Cubit<S> {
  BaseCubit({required S initialState, this.useCase}) : super(initialState);

  final UseCase<T, P>? useCase;

  @protected
  void safeEmit(S next) {
    if (!isClosed) emit(next);
  }

  Future<void> handleUseCase(
    P params, {
    required void Function(Failure failure) onFailure,
    required void Function(T data) onSuccess,
  }) async {
    if (useCase == null) return;
    final result = await useCase!.call(params);
    if (isClosed) return;
    result.fold(onFailure, onSuccess);
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../error/failures.dart';
import '../usecases/usecase.dart';

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

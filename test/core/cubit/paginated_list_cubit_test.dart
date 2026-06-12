import 'dart:async';

import 'package:crypto_tracker/src/core/cubit/paginated_list/paginated_list_cubit.dart';
import 'package:crypto_tracker/src/core/cubit/paginated_list/paginated_list_params.dart';
import 'package:crypto_tracker/src/core/cubit/paginated_list/paginated_response.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Params extends PaginatedListParams {
  const _Params({required super.page, required super.pageSize});
}

class _MockUseCase extends Mock
    implements UseCase<PaginatedResponse<int>, _Params> {}

class _TestCubit extends PaginatedListCubit<int, _Params> {
  _TestCubit(UseCase<PaginatedResponse<int>, _Params> uc)
      : super(useCase: uc, pageSize: 2);

  @override
  _Params buildParams(int page) => _Params(page: page, pageSize: pageSize);
}

void main() {
  setUpAll(() {
    registerFallbackValue(const _Params(page: 1, pageSize: 2));
  });

  late _MockUseCase uc;
  late List<Completer<Either<Failure, PaginatedResponse<int>>>> calls;

  setUp(() {
    uc = _MockUseCase();
    calls = [];
    when(() => uc.call(any())).thenAnswer((_) {
      final c = Completer<Either<Failure, PaginatedResponse<int>>>();
      calls.add(c);
      return c.future;
    });
  });

  test('a fetch while one is in flight is ignored', () async {
    final cubit = _TestCubit(uc);

    unawaited(cubit.fetchPage(page: 1));
    await Future<void>.value();
    unawaited(cubit.fetchPage(page: 1));
    await Future<void>.value();

    expect(calls, hasLength(1), reason: 'only the first fetch hit the use case');

    calls.first.complete(const Right(PaginatedResponse(items: [1, 2])));
    await cubit.close();
  });

  test('reset discards an in-flight page (stale generation does not append)',
      () async {
    final cubit = _TestCubit(uc);

    unawaited(cubit.fetchPage(page: 1));
    await Future<void>.value();

    final resetFuture = cubit.reset();
    await Future<void>.value();
    expect(calls, hasLength(2));

    calls[1].complete(const Right(PaginatedResponse(items: [9])));
    calls[0].complete(const Right(PaginatedResponse(items: [1, 2])));
    await resetFuture;

    expect(cubit.objects, [9], reason: 'only the post-reset page survives');
    await cubit.close();
  });
}

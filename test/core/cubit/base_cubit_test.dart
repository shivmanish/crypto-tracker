import 'package:crypto_tracker/src/core/cubit/base_cubit.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUseCase extends Mock implements UseCase<String, int> {}

class _TestCubit extends BaseCubit<String, String, int> {
  _TestCubit({super.useCase}) : super(initialState: 'init');

  Future<void> run(int p) => handleUseCase(
        p,
        onFailure: (_) => safeEmit('failure'),
        onSuccess: safeEmit,
      );

  void emitPublic(String s) => safeEmit(s);
}

void main() {
  test('handleUseCase is a no-op when no use case is configured', () async {
    final cubit = _TestCubit();
    await cubit.run(1);
    expect(cubit.state, 'init');
  });

  test('handleUseCase folds success into onSuccess', () async {
    final uc = _MockUseCase();
    when(() => uc.call(any())).thenAnswer((_) async => const Right('ok'));
    final cubit = _TestCubit(useCase: uc);
    await cubit.run(1);
    expect(cubit.state, 'ok');
  });

  test('handleUseCase folds failure into onFailure', () async {
    final uc = _MockUseCase();
    when(() => uc.call(any()))
        .thenAnswer((_) async => const Left(ServerFailure('x')));
    final cubit = _TestCubit(useCase: uc);
    await cubit.run(1);
    expect(cubit.state, 'failure');
  });

  test('safeEmit after close does not throw and does not change state',
      () async {
    final cubit = _TestCubit();
    await cubit.close();
    cubit.emitPublic('after');
    expect(cubit.state, 'init');
  });

  test('handleUseCase does not fold after the cubit is closed', () async {
    final uc = _MockUseCase();
    when(() => uc.call(any())).thenAnswer((_) async => const Right('ok'));
    final cubit = _TestCubit(useCase: uc);
    final future = cubit.run(1);
    await cubit.close();
    await future;
    expect(cubit.state, 'init');
  });
}

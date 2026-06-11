import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/global_market/global_market_cubit.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/global_market/global_market_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockGetGlobalMarketUseCase useCase;

  setUpAll(registerFallbacks);
  setUp(() => useCase = MockGetGlobalMarketUseCase());

  blocTest<GlobalMarketCubit, GlobalMarketState>(
    'emits [Loading, Loaded] on success',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => Right(globalModel()));
      return GlobalMarketCubit(useCase: useCase);
    },
    act: (c) => c.load(),
    expect: () => [const GlobalMarketLoading(), GlobalMarketLoaded(globalModel())],
  );

  blocTest<GlobalMarketCubit, GlobalMarketState>(
    'emits [Loading, Error] on failure',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => const Left(NetworkFailure('offline')));
      return GlobalMarketCubit(useCase: useCase);
    },
    act: (c) => c.load(),
    expect: () => [
      const GlobalMarketLoading(),
      const GlobalMarketError(NetworkFailure('offline')),
    ],
  );
}

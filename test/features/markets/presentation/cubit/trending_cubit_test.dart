import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/trending/trending_cubit.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/trending/trending_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockGetTrendingCoinsUseCase useCase;

  setUpAll(registerFallbacks);
  setUp(() => useCase = MockGetTrendingCoinsUseCase());

  blocTest<TrendingCubit, TrendingState>(
    'emits [Loading, Loaded] on success',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => Right([trendingModel()]));
      return TrendingCubit(useCase: useCase);
    },
    act: (c) => c.load(),
    expect: () => [
      const TrendingLoading(),
      TrendingLoaded([trendingModel()]),
    ],
  );

  blocTest<TrendingCubit, TrendingState>(
    'emits [Loading, Error] on failure',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => const Left(CacheFailure('no cache')));
      return TrendingCubit(useCase: useCase);
    },
    act: (c) => c.load(),
    expect: () => [
      const TrendingLoading(),
      const TrendingError(CacheFailure('no cache')),
    ],
  );
}

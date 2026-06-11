import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/coin_detail/coin_detail_cubit.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/coin_detail/coin_detail_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockGetCoinDetailUseCase useCase;

  setUpAll(registerFallbacks);
  setUp(() => useCase = MockGetCoinDetailUseCase());

  blocTest<CoinDetailCubit, CoinDetailState>(
    'emits [Loading, Loaded] on success',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => Right(coinDetailModel()));
      return CoinDetailCubit(useCase: useCase);
    },
    act: (c) => c.load('ethereum'),
    expect: () => [
      const CoinDetailLoading(),
      CoinDetailLoaded(coinDetailModel()),
    ],
  );

  blocTest<CoinDetailCubit, CoinDetailState>(
    'emits [Loading, Error] when offline with no cache',
    build: () {
      when(() => useCase.call(any())).thenAnswer(
        (_) async => const Left(NetworkFailure('offline')),
      );
      return CoinDetailCubit(useCase: useCase);
    },
    act: (c) => c.load('ethereum'),
    expect: () => [
      const CoinDetailLoading(),
      const CoinDetailError(NetworkFailure('offline')),
    ],
  );
}

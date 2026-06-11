import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/features/markets/domain/entities/coin_base_entity.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/coin_search/coin_search_cubit.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/coin_search/coin_search_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockSearchCoinsUseCase useCase;

  setUpAll(registerFallbacks);
  setUp(() => useCase = MockSearchCoinsUseCase());

  blocTest<CoinSearchCubit, CoinSearchState>(
    'a query below the min length stays inactive and never calls the use case',
    build: () => CoinSearchCubit(useCase: useCase),
    act: (c) => c.search('ab'),
    expect: () => const [CoinSearchInactive()],
    verify: (_) => verifyNever(() => useCase.call(any())),
  );

  blocTest<CoinSearchCubit, CoinSearchState>(
    'a valid query emits [Loading, Loaded]',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => const Right(<CoinBaseEntity>[]));
      return CoinSearchCubit(useCase: useCase);
    },
    act: (c) => c.search('bitcoin'),
    expect: () => const [
      CoinSearchLoading(),
      CoinSearchLoaded(query: 'bitcoin', results: []),
    ],
  );

  blocTest<CoinSearchCubit, CoinSearchState>(
    'offline failure emits an Error flagged isOffline',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => const Left(NetworkFailure('offline')));
      return CoinSearchCubit(useCase: useCase);
    },
    act: (c) => c.search('bitcoin'),
    expect: () => const [
      CoinSearchLoading(),
      CoinSearchError(query: 'bitcoin', failure: NetworkFailure('offline')),
    ],
    verify: (c) {
      final state = c.state as CoinSearchError;
      expect(state.isOffline, isTrue);
    },
  );

  blocTest<CoinSearchCubit, CoinSearchState>(
    'clearing the query after a search returns to inactive',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => const Right(<CoinBaseEntity>[]));
      return CoinSearchCubit(useCase: useCase);
    },
    act: (c) async {
      await c.search('bitcoin');
      await c.search('');
    },
    skip: 2,
    expect: () => const [CoinSearchInactive()],
  );
}

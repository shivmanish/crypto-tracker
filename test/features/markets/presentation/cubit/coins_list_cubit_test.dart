import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/src/core/cubit/paginated_list/paginated_list_state.dart';
import 'package:crypto_tracker/src/core/cubit/paginated_list/paginated_response.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/features/markets/domain/entities/coin_entity.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/coins_list/coins_list_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockGetCoinsUseCase useCase;

  setUpAll(registerFallbacks);
  setUp(() => useCase = MockGetCoinsUseCase());

  PaginatedResponse<CoinEntity> page({int? next}) =>
      PaginatedResponse(items: [coinModel(id: 'a')], nextPage: next);

  blocTest<CoinsListCubit, PaginatedListState<CoinEntity>>(
    'first fetch emits Loading(isFirstFetch:true) then Loaded',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => Right(page(next: 2)));
      return CoinsListCubit(useCase: useCase);
    },
    act: (c) => c.fetchPage(page: 1),
    expect: () => [
      const PaginatedListLoading<CoinEntity>(isFirstFetch: true),
      PaginatedListLoaded<CoinEntity>(response: page(next: 2)),
    ],
    verify: (c) {
      expect(c.objects, hasLength(1));
      expect(c.hasMorePages, isTrue);
    },
  );

  blocTest<CoinsListCubit, PaginatedListState<CoinEntity>>(
    'a short final page sets hasMorePages = false',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => Right(page(next: null)));
      return CoinsListCubit(useCase: useCase);
    },
    act: (c) => c.fetchPage(page: 1),
    verify: (c) => expect(c.hasMorePages, isFalse),
  );

  blocTest<CoinsListCubit, PaginatedListState<CoinEntity>>(
    'subsequent fetch appends (tail loader: isFirstFetch=false)',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => Right(page(next: 3)));
      return CoinsListCubit(useCase: useCase);
    },
    act: (c) async {
      await c.fetchPage(page: 1);
      await c.fetchPage(page: 2);
    },
    skip: 2, // skip the first Loading+Loaded
    expect: () => [
      const PaginatedListLoading<CoinEntity>(isFirstFetch: false),
      isA<PaginatedListLoaded<CoinEntity>>(),
    ],
    verify: (c) => expect(c.objects, hasLength(2)),
  );

  blocTest<CoinsListCubit, PaginatedListState<CoinEntity>>(
    'emits Error on failure',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => const Left(ServerFailure('boom')));
      return CoinsListCubit(useCase: useCase);
    },
    act: (c) => c.fetchPage(page: 1),
    expect: () => [
      const PaginatedListLoading<CoinEntity>(isFirstFetch: true),
      const PaginatedListError<CoinEntity>(failure: ServerFailure('boom')),
    ],
  );

  blocTest<CoinsListCubit, PaginatedListState<CoinEntity>>(
    'reset clears items and refetches from page 1',
    build: () {
      when(() => useCase.call(any()))
          .thenAnswer((_) async => Right(page(next: 2)));
      return CoinsListCubit(useCase: useCase);
    },
    act: (c) async {
      await c.fetchPage(page: 1);
      await c.reset();
    },
    verify: (c) {
      expect(c.objects, hasLength(1)); // cleared then refetched one page
    },
  );
}

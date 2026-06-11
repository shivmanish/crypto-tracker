import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/favorites/favorites_cubit.dart';
import 'package:crypto_tracker/src/features/markets/presentation/cubit/favorites/favorites_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockGetFavoriteIdsUseCase getFavorites;
  late MockSaveFavoritesUseCase saveFavorites;

  setUpAll(registerFallbacks);
  setUp(() {
    getFavorites = MockGetFavoriteIdsUseCase();
    saveFavorites = MockSaveFavoritesUseCase();
  });

  FavoritesCubit build() => FavoritesCubit(
        getFavoriteIds: getFavorites,
        saveFavorites: saveFavorites,
      );

  blocTest<FavoritesCubit, FavoritesState>(
    'load populates the id set',
    build: () {
      when(() => getFavorites.call(any()))
          .thenAnswer((_) async => const Right({'btc', 'eth'}));
      return build();
    },
    act: (c) => c.load(),
    expect: () => [const FavoritesState(ids: {'btc', 'eth'})],
    verify: (c) {
      expect(c.state.isFavorite('btc'), isTrue);
      expect(c.state.isFavorite('xrp'), isFalse);
    },
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'toggle adds optimistically and persists',
    build: () {
      when(() => saveFavorites.call(any()))
          .thenAnswer((_) async => const Right(null));
      return build();
    },
    act: (c) => c.toggle('btc'),
    expect: () => [const FavoritesState(ids: {'btc'})],
    verify: (_) => verify(() => saveFavorites.call({'btc'})).called(1),
  );

  blocTest<FavoritesCubit, FavoritesState>(
    'toggle reverts and surfaces the error when persistence fails',
    build: () {
      when(() => saveFavorites.call(any()))
          .thenAnswer((_) async => const Left(CacheFailure('disk full')));
      return build();
    },
    act: (c) => c.toggle('btc'),
    expect: () => [
      const FavoritesState(ids: {'btc'}), // optimistic add
      const FavoritesState(ids: {}, error: CacheFailure('disk full')), // revert
    ],
  );
}

import 'package:crypto_tracker/src/core/cubit/paginated_list/paginated_response.dart';
import 'package:crypto_tracker/src/core/usecases/usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/entities/coin_entity.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coin_detail_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_coins_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_favorite_ids_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_global_market_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/get_trending_coins_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/save_favorites_usecase.dart';
import 'package:crypto_tracker/src/features/markets/domain/usecases/search_coins_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockMarketsRepository repo;

  setUpAll(registerFallbacks);
  setUp(() => repo = MockMarketsRepository());

  test('GetCoinsUseCase delegates to repository.getCoins', () async {
    final response = PaginatedResponse<CoinEntity>(items: [coinModel()]);
    when(() => repo.getCoins(any()))
        .thenAnswer((_) async => Right(response));

    final result =
        await GetCoinsUseCase(repo)(const CoinsParams(page: 1, pageSize: 20));

    expect(result, Right<dynamic, PaginatedResponse<CoinEntity>>(response));
    verify(() => repo.getCoins(any())).called(1);
  });

  test('GetGlobalMarketUseCase delegates to repository.getGlobalMarket',
      () async {
    when(() => repo.getGlobalMarket(any()))
        .thenAnswer((_) async => Right(globalModel()));
    final result = await GetGlobalMarketUseCase(repo)(GlobalMarketParams());
    expect(result.isRight(), isTrue);
    verify(() => repo.getGlobalMarket(any())).called(1);
  });

  test('GetTrendingCoinsUseCase delegates to repository.getTrending',
      () async {
    when(() => repo.getTrending(any()))
        .thenAnswer((_) async => Right([trendingModel()]));
    final result = await GetTrendingCoinsUseCase(repo)(TrendingParams());
    expect(result.isRight(), isTrue);
    verify(() => repo.getTrending(any())).called(1);
  });

  test('GetCoinDetailUseCase delegates to repository.getCoinDetail', () async {
    when(() => repo.getCoinDetail(any()))
        .thenAnswer((_) async => Right(coinDetailModel()));
    final result = await GetCoinDetailUseCase(repo)(CoinDetailParams('eth'));
    expect(result.isRight(), isTrue);
    verify(() => repo.getCoinDetail(any())).called(1);
  });

  test('SearchCoinsUseCase delegates to repository.searchCoins', () async {
    when(() => repo.searchCoins(any())).thenAnswer((_) async => const Right([]));
    final result = await SearchCoinsUseCase(repo)(const SearchCoinsParams('b'));
    expect(result.isRight(), isTrue);
    verify(() => repo.searchCoins(any())).called(1);
  });

  test('GetFavoriteIdsUseCase delegates to repository.getFavoriteIds',
      () async {
    when(() => repo.getFavoriteIds())
        .thenAnswer((_) async => const Right({'btc'}));
    final result = await GetFavoriteIdsUseCase(repo)(const NoParams());
    expect(result.getOrElse(() => {}), {'btc'});
  });

  test('SaveFavoritesUseCase delegates to repository.saveFavoriteIds',
      () async {
    when(() => repo.saveFavoriteIds(any()))
        .thenAnswer((_) async => const Right(null));
    final result = await SaveFavoritesUseCase(repo)({'btc'});
    expect(result.isRight(), isTrue);
    verify(() => repo.saveFavoriteIds({'btc'})).called(1);
  });
}

part of 'injector.dart';

void useCasesSl(GetIt sl) {
  sl
    ..registerLazySingleton(() => GetGlobalMarketUseCase(sl()))
    ..registerLazySingleton(() => GetTrendingCoinsUseCase(sl()))
    ..registerLazySingleton(() => GetCoinsUseCase(sl()))
    ..registerLazySingleton(() => GetCoinDetailUseCase(sl()))
    ..registerLazySingleton(() => GetFavoriteIdsUseCase(sl()))
    ..registerLazySingleton(() => SaveFavoritesUseCase(sl()))
    ..registerLazySingleton(() => SearchCoinsUseCase(sl()));
}

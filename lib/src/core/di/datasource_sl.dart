part of 'injector.dart';

void dataSourcesSl(GetIt sl) {
  sl
    ..registerLazySingleton<MarketDataSource>(
      () => MarketsRemoteDataSourceImpl(sl<ApiClient>()),
    )
    ..registerLazySingleton<MarketLocalDataSource>(
      () => MarketsLocalDataSourceImpl(
        sl<LocalStorageService>(),
        sl<AppDatabase>(),
      ),
    );
}

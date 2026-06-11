part of 'injector.dart';

void repositorySl(GetIt sl) {
  sl.registerLazySingleton<MarketsRepository>(
    () => MarketsRepositoryImpl(
      remote: sl<MarketDataSource>(),
      local: sl<MarketLocalDataSource>(),
      connectivity: sl<ConnectivityService>(),
    ),
  );
}

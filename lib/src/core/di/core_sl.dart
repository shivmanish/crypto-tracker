part of 'injector.dart';

void coreSl(GetIt sl, {required LocalStorageService storage}) {
  sl
    ..registerSingleton<LocalStorageService>(storage)
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityPlusService.new)
    ..registerLazySingleton<ApiClient>(DioApiClient.new);
}

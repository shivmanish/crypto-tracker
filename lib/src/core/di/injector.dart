import 'package:get_it/get_it.dart';

import '../database/app_database.dart';
import '../network/api_client.dart';
import '../services/connectivity_plus_service.dart';
import '../services/connectivity_service.dart';
import '../services/local_storage_service.dart';
import '../../features/markets/data/datasource/market_data_source.dart';
import '../../features/markets/data/datasource/markets_local_datasource.dart';
import '../../features/markets/data/datasource/markets_remote_datasource.dart';
import '../../features/markets/data/repository_impl/markets_repository_impl.dart';
import '../../features/markets/domain/repository/markets_repository.dart';
import '../../features/markets/domain/usecases/get_coin_detail_usecase.dart';
import '../../features/markets/domain/usecases/get_coins_usecase.dart';
import '../../features/markets/domain/usecases/get_favorite_ids_usecase.dart';
import '../../features/markets/domain/usecases/get_global_market_usecase.dart';
import '../../features/markets/domain/usecases/get_trending_coins_usecase.dart';
import '../../features/markets/domain/usecases/save_favorites_usecase.dart';
import '../../features/markets/domain/usecases/search_coins_usecase.dart';

part 'core_sl.dart';
part 'datasource_sl.dart';
part 'repository_sl.dart';
part 'usecase_sl.dart';

final sl = GetIt.instance;

/// Composition root. Registrations are grouped by layer (core → datasource →
/// repository → usecase), not by feature. Cubits are NOT registered here —
/// screens build them in their own BlocProvider, pulling deps from [sl].
Future<void> initInjector({required LocalStorageService storage}) async {
  coreSl(sl, storage: storage);
  dataSourcesSl(sl);
  repositorySl(sl);
  useCasesSl(sl);
}

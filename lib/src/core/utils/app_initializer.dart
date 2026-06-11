import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/injector.dart';
import '../localization/app_locale_manager.dart';
import '../services/local_storage_service.dart';
import '../services/shared_preferences_local_storage.dart';
import '../theme/app_theme_manager.dart';

/// App bootstrap. Called once from main().
class AppInitializer {
  AppInitializer._();
  static final AppInitializer instance = AppInitializer._();

  bool _done = false;

  Future<void> bootstrap() async {
    if (_done) return;
    final sw = Stopwatch()..start();

    await _lockOrientation();

    final LocalStorageService storage = SharedPreferencesLocalStorage(
      await SharedPreferences.getInstance(),
    );

    await initInjector(storage: storage);
    await AppLocaleManager.instance.initialize(storage);
    await AppThemeManager.instance.initialize(storage);

    _done = true;
    debugPrint('[init] done in ${sw.elapsed.inMilliseconds}ms');
  }

  Future<void> _lockOrientation() {
    return SystemChrome.setPreferredOrientations(
      const [DeviceOrientation.portraitUp],
    );
  }
}

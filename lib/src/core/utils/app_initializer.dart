import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../di/injector.dart';
import '../localization/app_locale_manager.dart';
import '../services/local_storage_service.dart';
import '../services/shared_preferences_local_storage.dart';
import '../theme/app_theme_manager.dart';

class AppInitializer {
  AppInitializer._();
  static final AppInitializer instance = AppInitializer._();

  bool _done = false;

  Future<void> bootstrap() async {
    if (_done) return;
    final sw = Stopwatch()..start();

    _configurePlatform();

    final LocalStorageService storage = SharedPreferencesLocalStorage(
      await SharedPreferences.getInstance(),
    );

    await initInjector(storage: storage);
    await AppLocaleManager.instance.initialize(storage);
    await AppThemeManager.instance.initialize(storage);

    _done = true;
    debugPrint('[init] done in ${sw.elapsed.inMilliseconds}ms');
  }

  void _configurePlatform() {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return;
    }
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  }
}

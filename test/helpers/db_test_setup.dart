import 'package:crypto_tracker/src/core/database/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Call once in `setUpAll` to make sqflite run on the FFI backend (desktop /
/// CI), then build an in-memory [AppDatabase] per test for isolation.
void initFfi() {
  sqfliteFfiInit();
}

AppDatabase newInMemoryDb() =>
    AppDatabase(factory: databaseFactoryFfi, path: inMemoryDatabasePath);

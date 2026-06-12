import 'package:crypto_tracker/src/core/database/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initFfi() {
  sqfliteFfiInit();
}

AppDatabase newInMemoryDb() =>
    AppDatabase(factory: databaseFactoryFfi, path: inMemoryDatabasePath);

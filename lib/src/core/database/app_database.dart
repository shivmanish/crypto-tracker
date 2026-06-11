import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Owns the sqflite handle, schema version, and migrations. Bump [version] and
/// add a [_migrations] entry to evolve the schema — onCreate replays all
/// migrations, onUpgrade replays only the new ones.
class AppDatabase {
  AppDatabase({DatabaseFactory? factory, String? path})
      : _factory = factory ?? databaseFactory,
        // ignore: prefer_initializing_formals
        _path = path;

  static const String dbName = 'crypto_tracker.db';
  static const int version = 1;

  /// Migration N is the set of statements that move the schema *to* version N.
  static const Map<int, List<String>> _migrations = {
    1: [
      '''
      CREATE TABLE coins (
        id TEXT PRIMARY KEY,
        symbol TEXT NOT NULL,
        name TEXT NOT NULL,
        image TEXT,
        current_price REAL,
        market_cap REAL,
        market_cap_rank INTEGER,
        total_volume REAL,
        price_change_percentage_24h REAL,
        -- detail-only fields, filled when a coin's detail is opened online
        description TEXT,
        ath REAL,
        ath_change_percentage REAL,
        atl REAL,
        atl_change_percentage REAL,
        circulating_supply REAL,
        max_supply REAL,
        has_detail INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL
      )
      ''',
      'CREATE INDEX idx_coins_rank ON coins (market_cap_rank)',
      '''
      CREATE TABLE trending (
        id TEXT PRIMARY KEY,
        symbol TEXT NOT NULL,
        name TEXT NOT NULL,
        thumb TEXT,
        price REAL,
        price_change_percentage_24h REAL,
        market_cap_rank INTEGER
      )
      ''',
    ],
  };

  final DatabaseFactory _factory;
  final String? _path;
  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final dbPath = _path ?? p.join(await _factory.getDatabasesPath(), dbName);
    return _factory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: version,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, v) => _runMigrations(db, 0, v),
        onUpgrade: (db, from, to) => _runMigrations(db, from, to),
      ),
    );
  }

  Future<void> _runMigrations(Database db, int from, int to) async {
    for (var v = from + 1; v <= to; v++) {
      for (final stmt in _migrations[v] ?? const []) {
        await db.execute(stmt);
      }
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}

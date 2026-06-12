import 'package:sqflite/sqflite.dart';

import 'app_database.dart';
import 'db_mapper.dart';

class Dao<T> {
  Dao(this._db, this._mapper);

  final AppDatabase _db;
  final DbMapper<T> _mapper;

  Future<void> upsert(T item) async {
    final db = await _db.database;
    await db.insert(
      _mapper.table,
      _mapper.toDb(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertAll(List<T> items) async {
    if (items.isEmpty) return;
    final db = await _db.database;
    final batch = db.batch();
    for (final item in items) {
      batch.insert(
        _mapper.table,
        _mapper.toDb(item),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<T>> getAll({String? orderBy, int? limit, int? offset}) async {
    final db = await _db.database;
    final rows = await db.query(
      _mapper.table,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    return rows.map(_mapper.fromDb).toList(growable: false);
  }

  Future<T?> getById(Object id) async {
    final db = await _db.database;
    final rows = await db.query(
      _mapper.table,
      where: '${_mapper.primaryKey} = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : _mapper.fromDb(rows.first);
  }

  Future<bool> exists(Object id) async => (await getById(id)) != null;

  Future<void> delete(Object id) async {
    final db = await _db.database;
    await db.delete(
      _mapper.table,
      where: '${_mapper.primaryKey} = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteWhere(String where, List<Object?> whereArgs) async {
    final db = await _db.database;
    await db.delete(_mapper.table, where: where, whereArgs: whereArgs);
  }

  Future<int> count() async {
    final db = await _db.database;
    final rows = await db.rawQuery('SELECT COUNT(*) AS c FROM ${_mapper.table}');
    return (rows.first['c'] as int?) ?? 0;
  }

  Future<void> clear() async {
    final db = await _db.database;
    await db.delete(_mapper.table);
  }
}

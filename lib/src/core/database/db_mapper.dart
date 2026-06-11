/// Maps a domain/data type [T] to and from a sqflite row. Each table that uses
/// the generic [Dao] provides one of these.
abstract class DbMapper<T> {
  String get table;
  String get primaryKey;

  Map<String, Object?> toDb(T entity);
  T fromDb(Map<String, Object?> row);
}

abstract class DbMapper<T> {
  String get table;
  String get primaryKey;

  Map<String, Object?> toDb(T entity);
  T fromDb(Map<String, Object?> row);
}

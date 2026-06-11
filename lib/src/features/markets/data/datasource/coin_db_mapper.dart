import '../../../../core/database/db_mapper.dart';
import '../models/coin_model.dart';

/// Maps [CoinModel] to/from the sqflite `coins` table for the generic Dao.
class CoinDbMapper implements DbMapper<CoinModel> {
  @override
  String get table => 'coins';

  @override
  String get primaryKey => 'id';

  @override
  Map<String, Object?> toDb(CoinModel entity) => entity.toDbMap();

  @override
  CoinModel fromDb(Map<String, Object?> row) => CoinModel.fromDb(row);
}

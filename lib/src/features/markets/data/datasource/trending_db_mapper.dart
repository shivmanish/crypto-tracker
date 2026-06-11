import '../../../../core/database/db_mapper.dart';
import '../models/trending_coin_model.dart';

/// Maps [TrendingCoinModel] to/from the sqflite `trending` table.
class TrendingDbMapper implements DbMapper<TrendingCoinModel> {
  @override
  String get table => 'trending';

  @override
  String get primaryKey => 'id';

  @override
  Map<String, Object?> toDb(TrendingCoinModel entity) => entity.toDbMap();

  @override
  TrendingCoinModel fromDb(Map<String, Object?> row) =>
      TrendingCoinModel.fromDb(row);
}

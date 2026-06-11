import 'package:crypto_tracker/src/core/database/app_database.dart';
import 'package:crypto_tracker/src/core/database/dao.dart';
import 'package:crypto_tracker/src/features/markets/data/datasource/coin_db_mapper.dart';
import 'package:crypto_tracker/src/features/markets/data/models/coin_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/db_test_setup.dart';
import '../../helpers/fixtures.dart';

void main() {
  late AppDatabase db;
  late Dao<CoinModel> dao;

  setUpAll(initFfi);

  setUp(() {
    db = newInMemoryDb();
    dao = Dao<CoinModel>(db, CoinDbMapper());
  });

  tearDown(() => db.close());

  test('upsert + getById', () async {
    await dao.upsert(coinModel(id: 'btc'));
    final got = await dao.getById('btc');
    expect(got?.id, 'btc');
  });

  test('upsert replaces on conflicting primary key', () async {
    await dao.upsert(coinModel(id: 'btc', rank: 1));
    await dao.upsert(coinModel(id: 'btc', rank: 9));
    expect(await dao.count(), 1);
    expect((await dao.getById('btc'))?.marketCapRank, 9);
  });

  test('upsertAll + getAll with order/limit/offset', () async {
    await dao.upsertAll(
      List.generate(4, (i) => coinModel(id: 'c$i', rank: i + 1)),
    );
    final page = await dao.getAll(
      orderBy: 'market_cap_rank ASC',
      limit: 2,
      offset: 1,
    );
    expect(page.map((c) => c.id), ['c1', 'c2']);
  });

  test('upsertAll on empty list is a no-op', () async {
    await dao.upsertAll([]);
    expect(await dao.count(), 0);
  });

  test('exists / delete / deleteWhere / clear / count', () async {
    await dao.upsertAll([
      coinModel(id: 'a', rank: 1),
      coinModel(id: 'b', rank: 2),
      coinModel(id: 'c', rank: 200),
    ]);
    expect(await dao.exists('a'), isTrue);

    await dao.delete('a');
    expect(await dao.exists('a'), isFalse);

    await dao.deleteWhere('market_cap_rank > ?', [100]);
    expect(await dao.exists('c'), isFalse);
    expect(await dao.count(), 1);

    await dao.clear();
    expect(await dao.count(), 0);
  });

  test('getById returns null for a missing row', () async {
    expect(await dao.getById('nope'), isNull);
  });
}

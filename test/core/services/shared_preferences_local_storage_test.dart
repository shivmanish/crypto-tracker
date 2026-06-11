import 'package:crypto_tracker/src/core/error/exceptions.dart';
import 'package:crypto_tracker/src/core/services/shared_preferences_local_storage.dart';
import 'package:crypto_tracker/src/features/markets/data/models/global_market_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late SharedPreferencesLocalStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    storage = SharedPreferencesLocalStorage(prefs);
  });

  group('string KV', () {
    test('writeString then readString round-trips', () async {
      await storage.writeString('k', 'v');
      expect(await storage.readString('k'), 'v');
    });

    test('readString returns null for an absent key', () async {
      expect(await storage.readString('missing'), isNull);
    });

    test('remove deletes the key', () async {
      await storage.writeString('k', 'v');
      await storage.remove('k');
      expect(await storage.containsKey('k'), isFalse);
    });
  });

  group('typed JSON', () {
    test('write then read round-trips through the codec', () async {
      final model = GlobalMarketModel.fromApi({
        'data': {
          'total_market_cap': {'usd': 10.0},
          'total_volume': {'usd': 5.0},
          'market_cap_change_percentage_24h_usd': 1.0,
        },
      });
      await storage.write('m', model, (v) => v.toCacheJson());
      final back = await storage.read('m', GlobalMarketModel.fromCache);
      expect(back, model);
    });

    test('read returns null for an absent key', () async {
      expect(
        await storage.read('none', GlobalMarketModel.fromCache),
        isNull,
      );
    });

    test('read throws CacheException on malformed JSON', () async {
      await prefs.setString('bad', '{not json');
      expect(
        () => storage.read('bad', GlobalMarketModel.fromCache),
        throwsA(isA<CacheException>()),
      );
    });

    test('read throws CacheException when the value is not a JSON object',
        () async {
      await prefs.setString('arr', '[1,2,3]');
      expect(
        () => storage.read('arr', GlobalMarketModel.fromCache),
        throwsA(isA<CacheException>()),
      );
    });
  });
}

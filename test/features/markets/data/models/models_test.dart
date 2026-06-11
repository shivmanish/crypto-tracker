import 'package:crypto_tracker/src/features/markets/data/models/coin_detail_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/coin_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/global_market_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/search_coin_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/trending_coin_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';

void main() {
  group('CoinModel', () {
    test('fromApi maps fields and upper-cases the symbol', () {
      final m = CoinModel.fromApi(coinMarketsJson());
      expect(m.id, 'bitcoin');
      expect(m.symbol, 'BTC');
      expect(m.name, 'Bitcoin');
      expect(m.currentPrice, 76764.0);
      expect(m.marketCapRank, 1);
      expect(m.priceChangePercentage24h, -0.52);
    });

    test('fromApi tolerates missing/null fields with safe defaults', () {
      final m = CoinModel.fromApi({});
      expect(m.id, '');
      expect(m.symbol, '');
      expect(m.currentPrice, 0);
      expect(m.marketCapRank, 0);
    });

    test('fromDb and toDbMap round-trip the row columns', () {
      final original = coinModel();
      final row = original.toDbMap();
      final restored = CoinModel.fromDb(row);
      expect(restored.id, original.id);
      expect(restored.symbol, original.symbol);
      expect(restored.currentPrice, original.currentPrice);
      expect(restored.marketCapRank, original.marketCapRank);
    });

    test('toDbMap writes an updated_at timestamp', () {
      expect(coinModel().toDbMap()['updated_at'], isA<int>());
    });
  });

  group('GlobalMarketModel', () {
    test('fromApi reads nested usd values', () {
      final m = GlobalMarketModel.fromApi(globalJson());
      expect(m.totalMarketCapUsd, 2440000000000.0);
      expect(m.totalVolumeUsd, 93220000000.0);
      expect(m.marketCapChangePercentage24h, -0.42);
    });

    test('fromApi defaults to zero when data is absent', () {
      final m = GlobalMarketModel.fromApi({});
      expect(m.totalMarketCapUsd, 0);
      expect(m.totalVolumeUsd, 0);
    });

    test('toCacheJson and fromCache round-trip', () {
      final original = globalModel();
      final restored = GlobalMarketModel.fromCache(original.toCacheJson());
      expect(restored, original);
    });
  });

  group('TrendingCoinModel', () {
    test('fromApi reads nested data.price and the usd change', () {
      final m = trendingModel();
      expect(m.id, 'bonk');
      expect(m.symbol, 'BONK');
      expect(m.rank, 102);
      expect(m.price, 0.00000601);
      expect(m.priceChangePercentage24h, -1.36);
      expect(m.thumb, 'https://img/bonk.png');
    });

    test('fromDb and toDbMap round-trip', () {
      final original = trendingModel();
      final restored = TrendingCoinModel.fromDb(original.toDbMap());
      expect(restored.id, original.id);
      expect(restored.price, original.price);
      expect(restored.rank, original.rank);
    });
  });

  group('SearchCoinModel', () {
    test('fromApi maps identity fields (no price)', () {
      final m = SearchCoinModel.fromApi(
        (searchJson()['coins'] as List).first as Map<String, dynamic>,
      );
      expect(m.id, 'bitcoin');
      expect(m.symbol, 'BTC');
      expect(m.marketCapRank, 1);
      expect(m.image, 'https://img/btc.png');
    });
  });

  group('CoinDetailModel', () {
    test('fromApi reads market_data.usd, description and supply', () {
      final m = coinDetailModel();
      expect(m.id, 'ethereum');
      expect(m.symbol, 'ETH');
      expect(m.currentPrice, 2095.85);
      expect(m.ath, 4878.0);
      expect(m.atl, 0.43);
      expect(m.circulatingSupply, 120280000.0);
      expect(m.maxSupply, isNull);
      expect(m.isUncapped, isTrue);
      expect(m.isComplete, isTrue);
      expect(m.description, contains('Ethereum'));
    });

    test('partialFromCoin keeps list fields, zeros detail fields, !isComplete',
        () {
      final partial = CoinDetailModel.partialFromCoin(coinModel());
      expect(partial.isComplete, isFalse);
      expect(partial.currentPrice, 76764.0);
      expect(partial.marketCap, isNonZero);
      expect(partial.ath, 0);
      expect(partial.atl, 0);
      expect(partial.description, '');
    });

    test('fromDb reconstructs a full detail from an enriched row', () {
      final row = {
        'id': 'ethereum',
        'symbol': 'ETH',
        'name': 'Ethereum',
        'image': 'https://img/eth.png',
        'market_cap_rank': 2,
        'description': 'desc',
        'current_price': 2095.85,
        'market_cap': 253150000000.0,
        'total_volume': 9780000000.0,
        'price_change_percentage_24h': -0.13,
        'ath': 4878.0,
        'ath_change_percentage': -57.03,
        'atl': 0.43,
        'atl_change_percentage': 487306.98,
        'circulating_supply': 120280000.0,
        'max_supply': null,
        'has_detail': 1,
      };
      final m = CoinDetailModel.fromDb(row);
      expect(m.currentPrice, 2095.85);
      expect(m.ath, 4878.0);
      expect(m.isUncapped, isTrue);
    });
  });
}

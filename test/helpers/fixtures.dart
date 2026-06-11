import 'package:crypto_tracker/src/core/network/codecs.dart';
import 'package:crypto_tracker/src/features/markets/data/models/coin_detail_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/coin_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/global_market_model.dart';
import 'package:crypto_tracker/src/features/markets/data/models/trending_coin_model.dart';

/// ---- Raw API payloads (trimmed to the fields the models read) ----

JsonMap coinMarketsJson({String id = 'bitcoin'}) => {
      'id': id,
      'symbol': 'btc',
      'name': 'Bitcoin',
      'image': 'https://img/btc.png',
      'current_price': 76764.0,
      'market_cap': 1540000000000.0,
      'market_cap_rank': 1,
      'total_volume': 93220000000.0,
      'price_change_percentage_24h': -0.52,
    };

JsonMap globalJson() => {
      'data': {
        'total_market_cap': {'usd': 2440000000000.0},
        'total_volume': {'usd': 93220000000.0},
        'market_cap_change_percentage_24h_usd': -0.42,
      },
    };

JsonMap trendingJson() => {
      'coins': [
        {
          'item': {
            'id': 'bonk',
            'name': 'Bonk',
            'symbol': 'bonk',
            'market_cap_rank': 102,
            'large': 'https://img/bonk.png',
            'data': {
              'price': 0.00000601,
              'price_change_percentage_24h': {'usd': -1.36},
            },
          },
        },
      ],
    };

JsonMap coinDetailJson({String id = 'ethereum'}) => {
      'id': id,
      'symbol': 'eth',
      'name': 'Ethereum',
      'image': {'large': 'https://img/eth.png'},
      'market_cap_rank': 2,
      'description': {'en': 'Ethereum is a decentralized computing platform.'},
      'market_data': {
        'current_price': {'usd': 2095.85},
        'price_change_percentage_24h': -0.13,
        'market_cap': {'usd': 253150000000.0},
        'total_volume': {'usd': 9780000000.0},
        'ath': {'usd': 4878.0},
        'ath_change_percentage': {'usd': -57.03},
        'atl': {'usd': 0.43},
        'atl_change_percentage': {'usd': 487306.98},
        'circulating_supply': 120280000.0,
        'max_supply': null,
      },
    };

JsonMap searchJson() => {
      'coins': [
        {
          'id': 'bitcoin',
          'symbol': 'btc',
          'name': 'Bitcoin',
          'large': 'https://img/btc.png',
          'market_cap_rank': 1,
        },
      ],
    };

/// ---- Models ----

CoinModel coinModel({String id = 'bitcoin', int rank = 1}) => CoinModel(
      id: id,
      symbol: 'BTC',
      name: 'Bitcoin',
      image: 'https://img/btc.png',
      currentPrice: 76764.0,
      marketCap: 1540000000000.0,
      marketCapRank: rank,
      totalVolume: 93220000000.0,
      priceChangePercentage24h: -0.52,
    );

CoinDetailModel coinDetailModel({String id = 'ethereum'}) =>
    CoinDetailModel.fromApi(coinDetailJson(id: id));

GlobalMarketModel globalModel() => GlobalMarketModel.fromApi(globalJson());

TrendingCoinModel trendingModel({String id = 'bonk'}) =>
    TrendingCoinModel.fromApi(
      (trendingJson()['coins'] as List).first['item'] as JsonMap,
    );

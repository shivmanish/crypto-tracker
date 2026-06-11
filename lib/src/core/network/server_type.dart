import 'network_config.dart';

/// Which backend a route targets. One server today (CoinGecko); add an entry
/// here to point specific routes at a different base URL without touching the
/// client or the routes that stay on the default.
enum ServerType {
  coinGecko;

  String get baseUrl {
    switch (this) {
      case ServerType.coinGecko:
        return NetworkConfig.coinGeckoBaseUrl;
    }
  }
}

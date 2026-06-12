import 'network_config.dart';

enum ServerType {
  coinGecko;

  String get baseUrl {
    switch (this) {
      case ServerType.coinGecko:
        return NetworkConfig.coinGeckoBaseUrl;
    }
  }
}

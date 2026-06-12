class NetworkConfig {
  NetworkConfig._();

  static const String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);

  static const Map<String, String> commonHeaders = {
    'Accept': 'application/json',
  };

  static const int maxRetries = 2;
  static const Duration retryBackoff = Duration(seconds: 2);
}

class ServerException implements Exception {
  ServerException(this.message, {this.statusCode, this.body});

  final String message;
  final int? statusCode;
  final dynamic body;

  @override
  String toString() =>
      'ServerException(statusCode: $statusCode, message: $message)';
}

class NetworkException implements Exception {
  NetworkException([this.message = 'No internet connection.']);
  final String message;

  @override
  String toString() => 'NetworkException($message)';
}

/// CoinGecko free tier returns 429 when the rate limit is hit.
class RateLimitException implements Exception {
  RateLimitException([this.message = 'Rate limit exceeded. Try again shortly.']);
  final String message;

  @override
  String toString() => 'RateLimitException($message)';
}

class CacheException implements Exception {
  CacheException([this.message = 'Local cache read/write failed.']);
  final String message;

  @override
  String toString() => 'CacheException($message)';
}

class NotFoundException implements Exception {
  NotFoundException(this.message);
  final String message;

  @override
  String toString() => 'NotFoundException($message)';
}

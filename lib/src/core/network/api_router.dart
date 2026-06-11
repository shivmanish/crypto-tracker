import 'server_type.dart';

/// Describes a single endpoint. Each usecase's `Params` implements this so the
/// path + query live alongside the call that needs them.
///
/// Only the endpoint [path] is required. [serverType] defaults to CoinGecko —
/// override it to point a route at a different base URL. The HTTP verb is
/// chosen by which [ApiClient] method you call (getRequest/postRequest/...).
abstract class APIRouter {
  ServerType get serverType => ServerType.coinGecko;

  String get path;

  Map<String, dynamic>? get queryParams => null;

  Map<String, dynamic>? get headers => null;

  dynamic get body => null;
}

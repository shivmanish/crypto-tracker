import 'server_type.dart';

abstract class APIRouter {
  ServerType get serverType => ServerType.coinGecko;

  String get path;

  Map<String, dynamic>? get queryParams => null;

  Map<String, dynamic>? get headers => null;

  dynamic get body => null;
}

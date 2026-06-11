import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'connectivity_service.dart';

class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService([InternetConnection? internet])
      : _internet = internet ?? InternetConnection();

  final InternetConnection _internet;

  @override
  Future<ConnectivityStatus> currentStatus() async =>
      await _internet.hasInternetAccess
          ? ConnectivityStatus.online
          : ConnectivityStatus.offline;

  @override
  Stream<ConnectivityStatus> get statusStream => _internet.onStatusChange.map(
        (s) => s == InternetStatus.connected
            ? ConnectivityStatus.online
            : ConnectivityStatus.offline,
      );
}

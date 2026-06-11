import 'package:flutter/material.dart';

/// Root-level keys so non-widget code can reach navigator/messenger.
class AppGlobalKeys {
  AppGlobalKeys._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}

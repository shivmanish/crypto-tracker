import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/markets/presentation/screens/coin_detail_screen.dart';
import '../../features/markets/presentation/screens/markets_screen.dart';
import '../utils/app_global_keys.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: AppGlobalKeys.navigatorKey);

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MarketsRoute.page, path: '/', initial: true),
        AutoRoute(page: CoinDetailRoute.page, path: '/coin/:id'),
      ];
}

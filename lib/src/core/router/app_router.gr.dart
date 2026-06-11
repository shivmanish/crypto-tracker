// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CoinDetailScreen]
class CoinDetailRoute extends PageRouteInfo<CoinDetailRouteArgs> {
  CoinDetailRoute({
    required String coinId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         CoinDetailRoute.name,
         args: CoinDetailRouteArgs(coinId: coinId, key: key),
         rawPathParams: {'id': coinId},
         initialChildren: children,
       );

  static const String name = 'CoinDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CoinDetailRouteArgs>(
        orElse: () => CoinDetailRouteArgs(coinId: pathParams.getString('id')),
      );
      return CoinDetailScreen(coinId: args.coinId, key: args.key);
    },
  );
}

class CoinDetailRouteArgs {
  const CoinDetailRouteArgs({required this.coinId, this.key});

  final String coinId;

  final Key? key;

  @override
  String toString() {
    return 'CoinDetailRouteArgs{coinId: $coinId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CoinDetailRouteArgs) return false;
    return coinId == other.coinId && key == other.key;
  }

  @override
  int get hashCode => coinId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MarketsScreen]
class MarketsRoute extends PageRouteInfo<void> {
  const MarketsRoute({List<PageRouteInfo>? children})
    : super(MarketsRoute.name, initialChildren: children);

  static const String name = 'MarketsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MarketsScreen();
    },
  );
}

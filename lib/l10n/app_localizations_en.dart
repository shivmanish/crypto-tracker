// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Crypto Tracker';

  @override
  String get marketsTitle => 'Markets';

  @override
  String get liveLabel => 'LIVE / COINGECKO';

  @override
  String get marketCapShort => 'TOP 20 · 24H';

  @override
  String get vol24hShort => 'VOL 24H';

  @override
  String get trendingLabel => 'TRENDING · 24H';

  @override
  String coinsCount(int count) {
    return '$count COINS →';
  }

  @override
  String get searchHint => 'Search coins';

  @override
  String get columnAsset => 'ASSET';

  @override
  String get columnPrice => 'PRICE · 24H';

  @override
  String get marketStats => 'MARKET STATS';

  @override
  String get statMarketCap => 'MARKET CAP';

  @override
  String get statVolume24h => 'VOLUME 24H';

  @override
  String get statAllTimeHigh => 'ALL-TIME HIGH';

  @override
  String get statAllTimeLow => 'ALL-TIME LOW';

  @override
  String get statCirculatingSupply => 'CIRCULATING SUPPLY';

  @override
  String get statMaxSupply => 'MAX SUPPLY';

  @override
  String get uncapped => '∞ uncapped';

  @override
  String aboutCoin(String name) {
    return 'ABOUT $name';
  }

  @override
  String rankLabel(int rank) {
    return 'RANK #$rank';
  }

  @override
  String get retry => 'Retry';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get offlineBanner => 'You\'re offline — showing cached data';

  @override
  String get emptyCoinsTitle => 'No coins to show';

  @override
  String get offlineTitle => 'You\'re offline';

  @override
  String get searchOfflineMessage =>
      'Search needs an internet connection. Reconnect and try again.';

  @override
  String get noResultsTitle => 'No results';

  @override
  String get partialOfflineNote =>
      'Limited data offline — connect for full details';

  @override
  String get detailOfflineMessage =>
      'Connect to the internet to view this coin.';

  @override
  String noResults(String query) {
    return 'No coins match \"$query\"';
  }

  @override
  String get favorite => 'Favorite';

  @override
  String get favoriteAdded => 'Added to favorites';

  @override
  String get favoriteRemoved => 'Removed from favorites';

  @override
  String get rateLimited => 'Rate limit hit. Please wait a moment.';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get sourceCoinGecko => '○ SOURCE · COINGECKO';

  @override
  String get settings => 'Settings';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';
}

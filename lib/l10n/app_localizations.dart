import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Crypto Tracker'**
  String get appTitle;

  /// No description provided for @marketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Markets'**
  String get marketsTitle;

  /// No description provided for @liveLabel.
  ///
  /// In en, this message translates to:
  /// **'LIVE / COINGECKO'**
  String get liveLabel;

  /// No description provided for @marketCapShort.
  ///
  /// In en, this message translates to:
  /// **'TOP 20 · 24H'**
  String get marketCapShort;

  /// No description provided for @vol24hShort.
  ///
  /// In en, this message translates to:
  /// **'VOL 24H'**
  String get vol24hShort;

  /// No description provided for @trendingLabel.
  ///
  /// In en, this message translates to:
  /// **'TRENDING · 24H'**
  String get trendingLabel;

  /// No description provided for @coinsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} COINS →'**
  String coinsCount(int count);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search coins'**
  String get searchHint;

  /// No description provided for @columnAsset.
  ///
  /// In en, this message translates to:
  /// **'ASSET'**
  String get columnAsset;

  /// No description provided for @columnPrice.
  ///
  /// In en, this message translates to:
  /// **'PRICE · 24H'**
  String get columnPrice;

  /// No description provided for @marketStats.
  ///
  /// In en, this message translates to:
  /// **'MARKET STATS'**
  String get marketStats;

  /// No description provided for @statMarketCap.
  ///
  /// In en, this message translates to:
  /// **'MARKET CAP'**
  String get statMarketCap;

  /// No description provided for @statVolume24h.
  ///
  /// In en, this message translates to:
  /// **'VOLUME 24H'**
  String get statVolume24h;

  /// No description provided for @statAllTimeHigh.
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME HIGH'**
  String get statAllTimeHigh;

  /// No description provided for @statAllTimeLow.
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME LOW'**
  String get statAllTimeLow;

  /// No description provided for @statCirculatingSupply.
  ///
  /// In en, this message translates to:
  /// **'CIRCULATING SUPPLY'**
  String get statCirculatingSupply;

  /// No description provided for @statMaxSupply.
  ///
  /// In en, this message translates to:
  /// **'MAX SUPPLY'**
  String get statMaxSupply;

  /// No description provided for @uncapped.
  ///
  /// In en, this message translates to:
  /// **'∞ uncapped'**
  String get uncapped;

  /// No description provided for @aboutCoin.
  ///
  /// In en, this message translates to:
  /// **'ABOUT {name}'**
  String aboutCoin(String name);

  /// No description provided for @rankLabel.
  ///
  /// In en, this message translates to:
  /// **'RANK #{rank}'**
  String rankLabel(int rank);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline — showing cached data'**
  String get offlineBanner;

  /// No description provided for @emptyCoinsTitle.
  ///
  /// In en, this message translates to:
  /// **'No coins to show'**
  String get emptyCoinsTitle;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get offlineTitle;

  /// No description provided for @searchOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'Search needs an internet connection. Reconnect and try again.'**
  String get searchOfflineMessage;

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResultsTitle;

  /// No description provided for @partialOfflineNote.
  ///
  /// In en, this message translates to:
  /// **'Limited data offline — connect for full details'**
  String get partialOfflineNote;

  /// No description provided for @detailOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to view this coin.'**
  String get detailOfflineMessage;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No coins match \"{query}\"'**
  String noResults(String query);

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @favoriteAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoriteRemoved;

  /// No description provided for @rateLimited.
  ///
  /// In en, this message translates to:
  /// **'Rate limit hit. Please wait a moment.'**
  String get rateLimited;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @sourceCoinGecko.
  ///
  /// In en, this message translates to:
  /// **'○ SOURCE · COINGECKO'**
  String get sourceCoinGecko;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

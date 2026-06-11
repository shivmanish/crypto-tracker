// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'क्रिप्टो ट्रैकर';

  @override
  String get marketsTitle => 'मार्केट';

  @override
  String get liveLabel => 'लाइव / कॉइनगेको';

  @override
  String get marketCapShort => 'टॉप 20 · 24घं';

  @override
  String get vol24hShort => 'वॉल्यूम 24घं';

  @override
  String get trendingLabel => 'ट्रेंडिंग · 24घं';

  @override
  String coinsCount(int count) {
    return '$count सिक्के →';
  }

  @override
  String get searchHint => 'कॉइन खोजें';

  @override
  String get columnAsset => 'एसेट';

  @override
  String get columnPrice => 'कीमत · 24घं';

  @override
  String get marketStats => 'मार्केट आँकड़े';

  @override
  String get statMarketCap => 'मार्केट कैप';

  @override
  String get statVolume24h => 'वॉल्यूम 24घं';

  @override
  String get statAllTimeHigh => 'सर्वकालिक उच्च';

  @override
  String get statAllTimeLow => 'सर्वकालिक निम्न';

  @override
  String get statCirculatingSupply => 'प्रचलित आपूर्ति';

  @override
  String get statMaxSupply => 'अधिकतम आपूर्ति';

  @override
  String get uncapped => '∞ असीमित';

  @override
  String aboutCoin(String name) {
    return '$name के बारे में';
  }

  @override
  String rankLabel(int rank) {
    return 'रैंक #$rank';
  }

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get errorTitle => 'कुछ गलत हो गया';

  @override
  String get offlineBanner => 'आप ऑफ़लाइन हैं — सहेजा गया डेटा दिखा रहे हैं';

  @override
  String get emptyCoinsTitle => 'दिखाने के लिए कोई कॉइन नहीं';

  @override
  String get offlineTitle => 'आप ऑफ़लाइन हैं';

  @override
  String get searchOfflineMessage =>
      'खोज के लिए इंटरनेट कनेक्शन चाहिए। दोबारा कनेक्ट करके पुनः प्रयास करें।';

  @override
  String get noResultsTitle => 'कोई परिणाम नहीं';

  @override
  String get partialOfflineNote =>
      'ऑफ़लाइन सीमित डेटा — पूरी जानकारी के लिए कनेक्ट करें';

  @override
  String get detailOfflineMessage =>
      'इस कॉइन को देखने के लिए इंटरनेट से कनेक्ट करें।';

  @override
  String noResults(String query) {
    return '\"$query\" से मेल खाता कोई कॉइन नहीं';
  }

  @override
  String get favorite => 'पसंदीदा';

  @override
  String get favoriteAdded => 'पसंदीदा में जोड़ा गया';

  @override
  String get favoriteRemoved => 'पसंदीदा से हटाया गया';

  @override
  String get rateLimited =>
      'दर सीमा पार हो गई। कृपया थोड़ी देर प्रतीक्षा करें।';

  @override
  String get language => 'भाषा';

  @override
  String get theme => 'थीम';

  @override
  String get sourceCoinGecko => '○ स्रोत · कॉइनगेको';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';
}

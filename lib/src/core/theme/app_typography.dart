import 'package:flutter/material.dart';

/// Named text styles. Colors baked in for dark; light overrides below.
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.screenTitle,
    required this.appBarTitle,
    required this.label,
    required this.statValue,
    required this.priceLarge,
    required this.coinName,
    required this.coinSymbol,
    required this.coinPrice,
    required this.percent,
    required this.body,
    required this.about,
    required this.inputText,
    required this.inputHint,
  });

  /// "Markets" headline.
  final TextStyle screenTitle;

  /// Centered app-bar title — "ETH · RANK #2".
  final TextStyle appBarTitle;

  /// Small uppercase muted captions — "MARKET STATS", "TOP 20 · 24H".
  final TextStyle label;

  /// Stat-card value — "$2.44T".
  final TextStyle statValue;

  /// Detail-screen price — "$2,095.85".
  final TextStyle priceLarge;

  final TextStyle coinName;
  final TextStyle coinSymbol;
  final TextStyle coinPrice;
  final TextStyle percent;
  final TextStyle body;
  final TextStyle about;
  final TextStyle inputText;
  final TextStyle inputHint;

  static const Color _dPrimary = Color(0xFFF5F5F5);
  static const Color _dSecondary = Color(0xFF9CA3AF);
  static const Color _dMuted = Color(0xFF6B7280);

  static const AppTypography dark = AppTypography(
    screenTitle: TextStyle(
      color: _dPrimary,
      fontSize: 34,
      fontWeight: FontWeight.w800,
      height: 1.1,
      letterSpacing: -0.5,
    ),
    appBarTitle: TextStyle(
      color: _dSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.0,
    ),
    label: TextStyle(
      color: _dMuted,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.0,
    ),
    statValue: TextStyle(
      color: _dPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
    ),
    priceLarge: TextStyle(
      color: _dPrimary,
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.0,
      letterSpacing: -1.0,
    ),
    coinName: TextStyle(
      color: _dPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    coinSymbol: TextStyle(
      color: _dSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.3,
    ),
    coinPrice: TextStyle(
      color: _dPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    percent: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    body: TextStyle(
      color: _dPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    about: TextStyle(
      color: _dSecondary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.55,
    ),
    inputText: TextStyle(
      color: _dPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
    inputHint: TextStyle(
      color: _dMuted,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
  );

  static final AppTypography light = AppTypography(
    screenTitle: dark.screenTitle.copyWith(color: const Color(0xFF111111)),
    appBarTitle: dark.appBarTitle.copyWith(color: const Color(0xFF52525B)),
    label: dark.label.copyWith(color: const Color(0xFF9CA3AF)),
    statValue: dark.statValue.copyWith(color: const Color(0xFF111111)),
    priceLarge: dark.priceLarge.copyWith(color: const Color(0xFF111111)),
    coinName: dark.coinName.copyWith(color: const Color(0xFF111111)),
    coinSymbol: dark.coinSymbol.copyWith(color: const Color(0xFF52525B)),
    coinPrice: dark.coinPrice.copyWith(color: const Color(0xFF111111)),
    percent: dark.percent,
    body: dark.body.copyWith(color: const Color(0xFF111111)),
    about: dark.about.copyWith(color: const Color(0xFF52525B)),
    inputText: dark.inputText.copyWith(color: const Color(0xFF111111)),
    inputHint: dark.inputHint.copyWith(color: const Color(0xFF9CA3AF)),
  );

  @override
  AppTypography copyWith({
    TextStyle? screenTitle,
    TextStyle? appBarTitle,
    TextStyle? label,
    TextStyle? statValue,
    TextStyle? priceLarge,
    TextStyle? coinName,
    TextStyle? coinSymbol,
    TextStyle? coinPrice,
    TextStyle? percent,
    TextStyle? body,
    TextStyle? about,
    TextStyle? inputText,
    TextStyle? inputHint,
  }) {
    return AppTypography(
      screenTitle: screenTitle ?? this.screenTitle,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      label: label ?? this.label,
      statValue: statValue ?? this.statValue,
      priceLarge: priceLarge ?? this.priceLarge,
      coinName: coinName ?? this.coinName,
      coinSymbol: coinSymbol ?? this.coinSymbol,
      coinPrice: coinPrice ?? this.coinPrice,
      percent: percent ?? this.percent,
      body: body ?? this.body,
      about: about ?? this.about,
      inputText: inputText ?? this.inputText,
      inputHint: inputHint ?? this.inputHint,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      screenTitle: TextStyle.lerp(screenTitle, other.screenTitle, t)!,
      appBarTitle: TextStyle.lerp(appBarTitle, other.appBarTitle, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      statValue: TextStyle.lerp(statValue, other.statValue, t)!,
      priceLarge: TextStyle.lerp(priceLarge, other.priceLarge, t)!,
      coinName: TextStyle.lerp(coinName, other.coinName, t)!,
      coinSymbol: TextStyle.lerp(coinSymbol, other.coinSymbol, t)!,
      coinPrice: TextStyle.lerp(coinPrice, other.coinPrice, t)!,
      percent: TextStyle.lerp(percent, other.percent, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      about: TextStyle.lerp(about, other.about, t)!,
      inputText: TextStyle.lerp(inputText, other.inputText, t)!,
      inputHint: TextStyle.lerp(inputHint, other.inputHint, t)!,
    );
  }
}

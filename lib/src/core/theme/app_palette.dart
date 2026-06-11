import 'package:flutter/material.dart';

/// Semantic colors exposed as a [ThemeExtension] — `context.palette.foo`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.bgBase,
    required this.surfaceCard,
    required this.surfaceElevated,
    required this.inputBg,
    required this.divider,
    required this.accent,
    required this.onAccent,
    required this.priceUp,
    required this.priceDown,
    required this.favorite,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color bgBase;
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color inputBg;
  final Color divider;

  final Color accent;
  final Color onAccent;

  final Color priceUp;
  final Color priceDown;

  final Color favorite;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color shimmerBase;
  final Color shimmerHighlight;

  Color changeColor(num delta) => delta >= 0 ? priceUp : priceDown;

  static const AppPalette dark = AppPalette(
    bgBase: Color(0xFF0A0A0A),
    surfaceCard: Color(0xFF1A1C20),
    surfaceElevated: Color(0xFF232529),
    inputBg: Color(0xFF1E2024),
    divider: Color(0xFF2C2F36),
    accent: Color(0xFFF5F5F5),
    onAccent: Color(0xFF0A0A0A),
    priceUp: Color(0xFF22C55E),
    priceDown: Color(0xFFF87171),
    favorite: Color(0xFF4ADE80),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFF9CA3AF),
    textMuted: Color(0xFF6B7280),
    shimmerBase: Color(0xFF2A2C31),
    shimmerHighlight: Color(0xFF3A3D44),
  );

  static const AppPalette light = AppPalette(
    bgBase: Color(0xFFF3F1EC),
    surfaceCard: Color(0xFFEDEBE5),
    surfaceElevated: Color(0xFFFFFFFF),
    inputBg: Color(0xFFEDEBE5),
    divider: Color(0xFFDDD9D0),
    accent: Color(0xFF111111),
    onAccent: Color(0xFFFFFFFF),
    priceUp: Color(0xFF16A34A),
    priceDown: Color(0xFFDC2626),
    favorite: Color(0xFF16A34A),
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFF52525B),
    textMuted: Color(0xFF9CA3AF),
    shimmerBase: Color(0xFFE4E0D8),
    shimmerHighlight: Color(0xFFF1EEE8),
  );

  @override
  AppPalette copyWith({
    Color? bgBase,
    Color? surfaceCard,
    Color? surfaceElevated,
    Color? inputBg,
    Color? divider,
    Color? accent,
    Color? onAccent,
    Color? priceUp,
    Color? priceDown,
    Color? favorite,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppPalette(
      bgBase: bgBase ?? this.bgBase,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      inputBg: inputBg ?? this.inputBg,
      divider: divider ?? this.divider,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      priceUp: priceUp ?? this.priceUp,
      priceDown: priceDown ?? this.priceDown,
      favorite: favorite ?? this.favorite,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      bgBase: Color.lerp(bgBase, other.bgBase, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      inputBg: Color.lerp(inputBg, other.inputBg, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      priceUp: Color.lerp(priceUp, other.priceUp, t)!,
      priceDown: Color.lerp(priceDown, other.priceDown, t)!,
      favorite: Color.lerp(favorite, other.favorite, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
    );
  }
}

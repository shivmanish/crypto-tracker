import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => _build(
        palette: AppPalette.dark,
        typography: AppTypography.dark,
        brightness: Brightness.dark,
        statusBarIcons: Brightness.light,
      );

  static ThemeData get light => _build(
        palette: AppPalette.light,
        typography: AppTypography.light,
        brightness: Brightness.light,
        statusBarIcons: Brightness.dark,
      );

  static ThemeData _build({
    required AppPalette palette,
    required AppTypography typography,
    required Brightness brightness,
    required Brightness statusBarIcons,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: palette.accent,
      brightness: brightness,
      surface: palette.bgBase,
      primary: palette.accent,
      onPrimary: palette.onAccent,
      onSurface: palette.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'OpenSans',
      scaffoldBackgroundColor: palette.bgBase,
      dividerColor: palette.divider,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: palette.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: statusBarIcons,
          statusBarBrightness: brightness,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[palette, typography],
    );
  }
}

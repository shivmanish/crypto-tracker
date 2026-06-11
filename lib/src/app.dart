import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/app_localizations.dart';
import 'core/di/injector.dart';
import 'core/localization/app_locale_manager.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_manager.dart';
import 'core/utils/app_global_keys.dart';
import 'features/markets/presentation/cubit/favorites/favorites_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter _router = AppRouter();
  final AppThemeManager _themeManager = AppThemeManager.instance;
  final AppLocaleManager _localeManager = AppLocaleManager.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesCubit>(
      create: (_) =>
          FavoritesCubit(getFavoriteIds: sl(), saveFavorites: sl())..load(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_themeManager, _localeManager]),
        builder: (context, _) {
          return MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: _themeManager.activeMode,
            locale: _localeManager.activeLocale,
            supportedLocales: _localeManager.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: _router.config(),
            scaffoldMessengerKey: AppGlobalKeys.scaffoldMessengerKey,
            // clamp text scaling so accessibility settings don't break layout
            builder: (context, child) {
              final mq = MediaQuery.of(context);
              return MediaQuery(
                data: mq.copyWith(
                  textScaler: mq.textScaler.clamp(
                    minScaleFactor: 1.0,
                    maxScaleFactor: 1.2,
                  ),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

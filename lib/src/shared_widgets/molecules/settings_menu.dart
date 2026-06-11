import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/localization/app_locale_manager.dart';
import '../../core/theme/app_theme_manager.dart';
import '../atoms/circle_action_button.dart';
import '../atoms/option_chip.dart';

/// "⋯" app-bar action that opens the settings sheet (theme + language).
/// Reused across screens so the entry point stays consistent.
class OverflowMenuButton extends StatelessWidget {
  const OverflowMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleActionButton(
      tooltip: context.translate.settings,
      onTap: () => _showSettingsSheet(context),
      child: const Icon(Icons.more_horiz_rounded),
    );
  }
}

Future<void> _showSettingsSheet(BuildContext context) {
  // Transparent modal — the sheet paints its own background inside the
  // AnimatedBuilder so it recolors live when the theme changes while open.
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const _SettingsSheet(),
  );
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final themeManager = AppThemeManager.instance;
    final localeManager = AppLocaleManager.instance;

    // Rebuild live as the user picks, so the sheet stays open and the
    // selection highlight updates immediately.
    return AnimatedBuilder(
      animation: Listenable.merge([themeManager, localeManager]),
      builder: (context, _) {
        final palette = context.palette;
        final l = context.translate;
        final mode = themeManager.activeMode;
        final lang = localeManager.activeLocale.languageCode;

        return Container(
          decoration: BoxDecoration(
            color: palette.surfaceElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: palette.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    l.settings,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                _SectionLabel(icon: Icons.brightness_6_rounded, label: l.theme),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OptionChip(
                      label: l.themeSystem,
                      selected: mode == ThemeMode.system,
                      onTap: () => themeManager.setMode(ThemeMode.system),
                    ),
                    OptionChip(
                      label: l.themeLight,
                      selected: mode == ThemeMode.light,
                      onTap: () => themeManager.setMode(ThemeMode.light),
                    ),
                    OptionChip(
                      label: l.themeDark,
                      selected: mode == ThemeMode.dark,
                      onTap: () => themeManager.setMode(ThemeMode.dark),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SectionLabel(icon: Icons.language_rounded, label: l.language),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OptionChip(
                      label: 'English',
                      selected: lang == 'en',
                      onTap: () => localeManager.setLocale(const Locale('en')),
                    ),
                    OptionChip(
                      label: 'हिंदी',
                      selected: lang == 'hi',
                      onTap: () => localeManager.setLocale(const Locale('hi')),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        Icon(icon, size: 18, color: palette.textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

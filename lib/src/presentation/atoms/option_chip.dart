import 'package:flutter/material.dart';

import '../../core/constants/app_durations.dart';
import '../../core/extensions/context_extensions.dart';

/// Selectable pill used for single-choice settings (theme mode, language).
class OptionChip extends StatelessWidget {
  const OptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? palette.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? palette.accent : palette.divider),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? palette.onAccent : palette.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/extensions/num_extensions.dart';

/// Small tinted pill showing a signed 24h percentage, colored up/down.
class PercentBadge extends StatelessWidget {
  const PercentBadge({
    super.key,
    required this.value,
    this.compact = false,
    this.showArrow = false,
  });

  final double value;

  /// Tighter padding for dense rows.
  final bool compact;

  /// Leading ▲/▼ direction caret (used on the detail header badge).
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final color = context.palette.changeColor(value);
    final style = context.typography.percent.copyWith(color: color);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 6,
        vertical: compact ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showArrow)
            Icon(
              value.isPositive
                  ? Icons.arrow_drop_up_rounded
                  : Icons.arrow_drop_down_rounded,
              size: 16,
              color: color,
            ),
          Text(value.asSignedPercent, style: style),
        ],
      ),
    );
  }
}

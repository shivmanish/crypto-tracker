import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';

class CircleActionButton extends StatelessWidget {
  const CircleActionButton({
    super.key,
    required this.onTap,
    required this.tooltip,
    required this.child,
    this.size = 40,
  });

  final VoidCallback onTap;
  final String tooltip;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: palette.surfaceCard,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: IconTheme.merge(
                data: IconThemeData(
                  color: palette.textSecondary,
                  size: size * 0.46,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

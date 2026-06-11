import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/extensions/context_extensions.dart';

/// Theme-aware shimmer placeholder for skeleton loading (preferred over a
/// spinner). Base/highlight derive from the palette so it adapts to light/dark.
/// [ShimmerBox.rect] for bars/cards, [ShimmerBox.circle] for logos/avatars.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox.rect({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  }) : _shape = BoxShape.rectangle;

  const ShimmerBox.circle({super.key, required double size})
      : width = size,
        height = size,
        borderRadius = 0,
        _shape = BoxShape.circle;

  final double width;
  final double height;
  final double borderRadius;
  final BoxShape _shape;

  @override
  Widget build(BuildContext context) {
    // Opaque, theme-tuned tones from the palette: a placeholder block (base)
    // with a lighter sweeping sheen (highlight).
    final base = context.palette.shimmerBase;
    final highlight = context.palette.shimmerHighlight;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          shape: _shape,
          borderRadius: _shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius)
              : null,
        ),
      ),
    );
  }
}

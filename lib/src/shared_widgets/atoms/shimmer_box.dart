import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/extensions/context_extensions.dart';

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

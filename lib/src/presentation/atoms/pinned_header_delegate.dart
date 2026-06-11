import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Reusable [SliverPersistentHeaderDelegate] for sticky headers in a
/// CustomScrollView. Use with `SliverPersistentHeader(pinned: true, ...)`.
/// [background] is painted behind the child so scrolling content can't show
/// through the pinned area.
class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  PinnedHeaderDelegate({
    required this.child,
    required this.height,
    this.background,
  });

  final Widget child;
  final double height;
  final Color? background;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => math.max(height, minExtent);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(color: background, child: child);
  }

  @override
  bool shouldRebuild(PinnedHeaderDelegate oldDelegate) {
    return height != oldDelegate.height ||
        background != oldDelegate.background ||
        child != oldDelegate.child;
  }
}

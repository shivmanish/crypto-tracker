import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';
import 'shimmer_box.dart';

class CoinLogo extends StatelessWidget {
  const CoinLogo({
    super.key,
    required this.url,
    this.symbol = '',
    this.size = 36,
  });

  final String url;
  final String symbol;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback(context);
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, _) => ShimmerBox.circle(size: size),
        errorWidget: (_, _, _) => _fallback(context),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        shape: BoxShape.circle,
      ),
      child: Text(
        symbol.isNotEmpty ? symbol.characters.first.toUpperCase() : '?',
        style: TextStyle(
          color: palette.textSecondary,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}

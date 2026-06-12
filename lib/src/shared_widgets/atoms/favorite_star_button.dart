import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';

class FavoriteStarButton extends StatelessWidget {
  const FavoriteStarButton({
    super.key,
    required this.isFavorite,
    this.onTap,
    this.size = 22,
  });

  final bool isFavorite;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkResponse(
      onTap: onTap,
      radius: size,
      child: Icon(
        isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
        size: size,
        color: isFavorite ? palette.favorite : palette.textMuted,
      ),
    );
  }
}

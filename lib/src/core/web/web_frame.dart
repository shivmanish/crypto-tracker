import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WebFrame extends StatelessWidget {
  const WebFrame({super.key, required this.child, this.maxWidth = 500});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    final mq = MediaQuery.of(context);
    final frameWidth = min(maxWidth, mq.size.width);
    return ColoredBox(
      color: const Color(0xFF1F1F1F),
      child: Center(
        child: ClipRect(
          child: SizedBox(
            width: frameWidth,
            child: MediaQuery(
              data: mq.copyWith(size: Size(frameWidth, mq.size.height)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

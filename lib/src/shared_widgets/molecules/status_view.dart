import 'package:flutter/material.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/extensions/context_extensions.dart';

/// Centered icon + title + message (+ optional retry) for empty / offline /
/// error states. Reusable across features.
class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel,
  });

  final IconData icon;
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final type = context.typography;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.gutter * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: palette.textMuted),
            const SizedBox(height: AppDimens.gap),
            Text(title, style: type.coinName, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppDimens.gapSm),
              Text(
                message!,
                style: type.coinSymbol,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppDimens.gutter),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(retryLabel ?? context.translate.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

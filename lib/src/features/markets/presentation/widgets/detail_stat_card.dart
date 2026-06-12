import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/extensions/context_extensions.dart';

class DetailStatCard extends StatelessWidget {
  const DetailStatCard({
    super.key,
    required this.label,
    required this.value,
    this.sub,
    this.subColor,
  });

  final String label;
  final String value;
  final String? sub;
  final Color? subColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final type = context.typography;
    return Container(
      padding: const EdgeInsets.all(AppDimens.gap),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
        border: Border.all(color: palette.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: type.label),
          const SizedBox(height: 6),
          Text(
            value,
            style: type.coinName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (sub != null) ...[
            const SizedBox(height: 2),
            Text(sub!, style: type.percent.copyWith(color: subColor)),
          ],
        ],
      ),
    );
  }
}

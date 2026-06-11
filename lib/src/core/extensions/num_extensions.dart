import 'package:intl/intl.dart';

/// Money / market formatting used across the markets + detail UI.
extension NumX on num {
  /// `$76,764.00`, `$0.00000601` — adapts precision to magnitude so
  /// sub-cent coins stay readable.
  String get asPrice {
    final abs = this.abs();
    final int decimals;
    if (abs == 0) {
      decimals = 2;
    } else if (abs >= 1) {
      decimals = 2;
    } else if (abs >= 0.01) {
      decimals = 4;
    } else {
      decimals = 8;
    }
    return NumberFormat.currency(symbol: r'$', decimalDigits: decimals)
        .format(this);
  }

  /// Adaptive-precision price without a currency symbol — `76,764.00`,
  /// `0.00000601`. Used where the `$` is implied (trending cards).
  String get asPlainPrice {
    final abs = this.abs();
    final int decimals;
    if (abs == 0 || abs >= 1) {
      decimals = abs >= 1 ? 4 : 2;
    } else if (abs >= 0.01) {
      decimals = 6;
    } else {
      decimals = 8;
    }
    return NumberFormat('#,##0.${'0' * decimals}').format(this);
  }

  /// `$2.44T`, `$93.22B`, `$253.15M` — compact market-cap / volume.
  String get asCompactUsd {
    final f = NumberFormat.compactCurrency(symbol: r'$', decimalDigits: 2);
    return f.format(this).toUpperCase();
  }

  /// `120.28M`, `1,234` — compact plain number (supply counts).
  String get asCompact => NumberFormat.compact().format(this).toUpperCase();

  /// `-0.52%`, `+15.31%` — signed percent badge text.
  String get asSignedPercent {
    final sign = this >= 0 ? '+' : '';
    return '$sign${toStringAsFixed(2)}%';
  }

  bool get isPositive => this >= 0;
}

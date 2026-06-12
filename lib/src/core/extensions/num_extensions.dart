import 'package:intl/intl.dart';

extension NumX on num {
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

  String get asCompactUsd {
    final f = NumberFormat.compactCurrency(symbol: r'$', decimalDigits: 2);
    return f.format(this).toUpperCase();
  }

  String get asCompact => NumberFormat.compact().format(this).toUpperCase();

  String get asSignedPercent {
    final sign = this >= 0 ? '+' : '';
    return '$sign${toStringAsFixed(2)}%';
  }

  bool get isPositive => this >= 0;
}

import 'package:crypto_tracker/src/core/extensions/num_extensions.dart';
import 'package:crypto_tracker/src/core/extensions/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumX', () {
    test('asPrice adapts precision to magnitude', () {
      expect(76764.0.asPrice, r'$76,764.00');
      expect(0.00000601.asPrice, r'$0.00000601'); // 8 decimals for sub-cent
    });

    test('asCompactUsd renders compact, upper-cased units', () {
      expect(2440000000000.0.asCompactUsd, r'$2.44T');
      expect(93220000000.0.asCompactUsd, r'$93.2B');
    });

    test('asSignedPercent prefixes a sign', () {
      expect(15.31.asSignedPercent, '+15.31%');
      expect((-0.52).asSignedPercent, '-0.52%');
    });

    test('isPositive treats zero as positive', () {
      expect(0.isPositive, isTrue);
      expect((-1).isPositive, isFalse);
    });

    test('asCompact upper-cases supply counts', () {
      expect(120280000.asCompact, '120M');
    });
  });

  group('StringX', () {
    test('isBlank / isNotBlank', () {
      expect('   '.isBlank, isTrue);
      expect(' a '.isNotBlank, isTrue);
    });

    test('capitalize', () {
      expect('bitcoin'.capitalize, 'Bitcoin');
      expect(''.capitalize, '');
    });

    test('ellipsize truncates past the limit', () {
      expect('abcdef'.ellipsize(3), 'abc…');
      expect('ab'.ellipsize(3), 'ab');
    });
  });
}

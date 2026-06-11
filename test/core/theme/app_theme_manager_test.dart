import 'package:crypto_tracker/src/core/theme/app_theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockLocalStorageService storage;
  final manager = AppThemeManager.instance; // fresh per test-file isolate

  setUp(() {
    storage = MockLocalStorageService();
    when(() => storage.writeString(any(), any())).thenAnswer((_) async {});
  });

  test('setMode before initialize throws StateError', () {
    expect(() => manager.setMode(ThemeMode.dark), throwsStateError);
  });

  test('initialize decodes the stored mode then cycle advances + persists',
      () async {
    when(() => storage.readString(any())).thenAnswer((_) async => 'dark');

    await manager.initialize(storage);
    expect(manager.isInitialized, isTrue);
    expect(manager.activeMode, ThemeMode.dark); // decoded from storage

    // cycle order is system → light → dark → system
    expect(manager.cycle(), ThemeMode.system);
    expect(manager.cycle(), ThemeMode.light);
    expect(manager.cycle(), ThemeMode.dark);

    verify(() => storage.writeString(any(), any())).called(3);
  });

  test('initialize is idempotent (second call is a no-op)', () async {
    when(() => storage.readString(any())).thenAnswer((_) async => 'light');
    await manager.initialize(storage); // already initialized above
    // mode is whatever the previous test left it; not re-read from storage
    verifyNever(() => storage.readString(any()));
  });

  test('setMode to the current mode does not notify or persist', () {
    final current = manager.activeMode;
    manager.setMode(current);
    verifyNever(() => storage.writeString(any(), any()));
  });
}

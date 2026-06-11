import 'package:crypto_tracker/src/core/localization/app_locale_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockLocalStorageService storage;
  final manager = AppLocaleManager.instance; // fresh per test-file isolate

  setUp(() {
    storage = MockLocalStorageService();
    when(() => storage.writeString(any(), any())).thenAnswer((_) async {});
  });

  test('setLocale before initialize throws StateError', () {
    expect(() => manager.setLocale(const Locale('hi')), throwsStateError);
  });

  test('initialize resolves the stored locale code', () async {
    when(() => storage.readString(any())).thenAnswer((_) async => 'hi');
    await manager.initialize(storage);
    expect(manager.activeLocale, const Locale('hi'));
  });

  test('setLocale switches and persists; an unsupported code is ignored',
      () async {
    manager.setLocale(const Locale('en'));
    expect(manager.activeLocale, const Locale('en'));

    manager.setLocale(const Locale('fr')); // unsupported → no change
    expect(manager.activeLocale, const Locale('en'));
  });

  test('cycleLocale toggles between the supported locales', () {
    manager.setLocale(const Locale('en'));
    expect(manager.cycleLocale(), const Locale('hi'));
    expect(manager.cycleLocale(), const Locale('en'));
  });

  test('supportedLocales is unmodifiable', () {
    expect(
      () => manager.supportedLocales.add(const Locale('fr')),
      throwsUnsupportedError,
    );
  });
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

/// Reactive locale source for MaterialApp. Persists via [LocalStorageService].
class AppLocaleManager with ChangeNotifier {
  AppLocaleManager._();

  static final AppLocaleManager instance = AppLocaleManager._();

  static const String _storageKey = 'crypto.app_locale_code';

  static const List<Locale> _supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  LocalStorageService? _storage;
  Locale _activeLocale = _supportedLocales.first;
  bool _initialized = false;

  bool get isInitialized => _initialized;
  Locale get activeLocale => _activeLocale;
  List<Locale> get supportedLocales => List.unmodifiable(_supportedLocales);

  Future<void> initialize(LocalStorageService storage) async {
    if (_initialized) return;
    _storage = storage;
    final stored = await storage.readString(_storageKey);
    _activeLocale = _resolve(stored) ?? _supportedLocales.first;
    _initialized = true;
  }

  void setLocale(Locale locale) {
    if (!_initialized) {
      throw StateError('AppLocaleManager not initialized. Call initialize().');
    }
    final resolved = _resolve(locale.languageCode);
    if (resolved == null || resolved == _activeLocale) return;
    _activeLocale = resolved;
    notifyListeners();
    unawaited(_persist(resolved.languageCode));
  }

  /// Toggles between English and the native locale.
  Locale cycleLocale() {
    if (!_initialized) return _activeLocale;
    final i = _supportedLocales.indexOf(_activeLocale);
    final next = _supportedLocales[(i + 1) % _supportedLocales.length];
    setLocale(next);
    return next;
  }

  Locale? _resolve(String? code) {
    if (code == null || code.isEmpty) return null;
    for (final l in _supportedLocales) {
      if (l.languageCode == code) return l;
    }
    return null;
  }

  Future<void> _persist(String code) async {
    try {
      await _storage?.writeString(_storageKey, code);
    } catch (_) {
      // best-effort
    }
  }
}

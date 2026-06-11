import 'dart:async';

import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

/// Persisted ThemeMode source for MaterialApp. Defaults to system (assignment
/// requires system-detected theme).
class AppThemeManager with ChangeNotifier {
  AppThemeManager._();

  static final AppThemeManager instance = AppThemeManager._();

  static const String _storageKey = 'crypto.theme_mode';

  LocalStorageService? _storage;
  ThemeMode _activeMode = ThemeMode.system;
  bool _initialized = false;

  bool get isInitialized => _initialized;
  ThemeMode get activeMode => _activeMode;

  Future<void> initialize(LocalStorageService storage) async {
    if (_initialized) return;
    _storage = storage;
    final stored = await storage.readString(_storageKey);
    _activeMode = _decode(stored) ?? ThemeMode.system;
    _initialized = true;
  }

  void setMode(ThemeMode mode) {
    if (!_initialized) {
      throw StateError('AppThemeManager not initialized. Call initialize().');
    }
    if (mode == _activeMode) return;
    _activeMode = mode;
    notifyListeners();
    unawaited(_persist(mode));
  }

  /// Cycles system → light → dark.
  ThemeMode cycle() {
    const order = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    final next = order[(order.indexOf(_activeMode) + 1) % order.length];
    setMode(next);
    return next;
  }

  Future<void> _persist(ThemeMode mode) async {
    try {
      await _storage?.writeString(_storageKey, mode.name);
    } catch (_) {
      // best-effort
    }
  }

  ThemeMode? _decode(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }
}

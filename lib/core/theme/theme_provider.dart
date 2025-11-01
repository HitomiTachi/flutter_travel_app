import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';

enum AppThemeMode { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  static const String _storageKey = 'theme_mode';

  AppThemeMode _mode = AppThemeMode.system;
  AppThemeMode get mode => _mode;

  ThemeMode get themeMode {
    switch (_mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  Future<void> load() async {
    final String? saved = LocalStorageHelper.getValue(_storageKey) as String?;
    if (saved == 'light') _mode = AppThemeMode.light;
    if (saved == 'dark') _mode = AppThemeMode.dark;
    if (saved == 'system' || saved == null) _mode = AppThemeMode.system;
    notifyListeners();
  }

  Future<void> setMode(AppThemeMode newMode) async {
    _mode = newMode;
    final String toSave = newMode == AppThemeMode.light
        ? 'light'
        : newMode == AppThemeMode.dark
        ? 'dark'
        : 'system';
    LocalStorageHelper.setValue(_storageKey, toSave);
    notifyListeners();
  }
}

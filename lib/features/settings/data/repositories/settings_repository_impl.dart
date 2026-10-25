import 'package:flutter/material.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../../../core/storage/local_storage_service.dart';

/// [SettingsRepositoryImpl], ayarları `settings_box` yerel kutusunda saklar.
class SettingsRepositoryImpl implements SettingsRepository {
  static const String _boxKey = 'settings_box';

  final LocalStorageService _storage;

  SettingsRepositoryImpl({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService.instance;

  @override
  Future<AppSettings> getSettings() async {
    final rawData = await _storage.read(_boxKey);
    if (rawData != null && rawData is Map<String, dynamic>) {
      final modeStr = rawData['themeMode'] as String? ?? 'system';
      final lang = rawData['languageCode'] as String? ?? 'tr';
      final mode = _themeModeFromString(modeStr);
      return AppSettings(themeMode: mode, languageCode: lang);
    }
    return AppSettings.initial();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _storage.write(_boxKey, {
      'themeMode': settings.themeMode.name,
      'languageCode': settings.languageCode,
    });
  }

  ThemeMode _themeModeFromString(String modeStr) {
    switch (modeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

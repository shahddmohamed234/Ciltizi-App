import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// [SettingsCubit] sınıfı, uygulamanın tema seçimini ve ayarlarını yönetir.
class SettingsCubit extends Cubit<AppSettings> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(AppSettings.initial());

  /// Ayarları yerel depolamadan yükler
  Future<void> loadSettings() async {
    final settings = await _repository.getSettings();
    emit(settings);
  }

  /// Tema modunu değiştirir ve kalıcı olarak kaydeder
  Future<void> setThemeMode(ThemeMode mode) async {
    final updated = state.copyWith(themeMode: mode);
    emit(updated);
    await _repository.saveSettings(updated);
  }

  /// Dil tercihini günceller ve kalıcı olarak kaydeder
  Future<void> setLanguage(String langCode) async {
    final updated = state.copyWith(languageCode: langCode);
    emit(updated);
    await _repository.saveSettings(updated);
  }
}

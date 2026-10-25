import 'package:flutter/material.dart';

/// [AppSettings] sınıfı, kullanıcının tema modu, dil tercihi ve uygulama ayarlarını tutar.
class AppSettings {
  /// Tema modu: ThemeMode.system, ThemeMode.light veya ThemeMode.dark
  final ThemeMode themeMode;

  /// Dil tercihi: 'tr' (Türkçe) veya 'en' (English)
  final String languageCode;

  const AppSettings({
    required this.themeMode,
    this.languageCode = 'tr',
  });

  /// Varsayılan ayarlar (Sistem teması ve Türkçe dil)
  factory AppSettings.initial() {
    return const AppSettings(
      themeMode: ThemeMode.system,
      languageCode: 'tr',
    );
  }

  /// Ayarları güncelleme metodu
  AppSettings copyWith({
    ThemeMode? themeMode,
    String? languageCode,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

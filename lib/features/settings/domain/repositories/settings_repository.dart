import '../entities/app_settings.dart';

/// [SettingsRepository] arayüzü, kullanıcı ayarlarının yerel kalıcılığını yönetir.
abstract class SettingsRepository {
  /// Kayıtlı ayarları getirir
  Future<AppSettings> getSettings();

  /// Ayarları kaydeder
  Future<void> saveSettings(AppSettings settings);
}

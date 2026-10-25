import '../entities/skin_profile.dart';

/// [ProfileRepository] arayüzü, kullanıcı profilinin okunması ve
/// güncellenmesi işlemlerini soyutlayan Domain sözleşmesidir.
abstract class ProfileRepository {
  /// Kayıtlı kullanıcı cilt profilini getirir
  Future<SkinProfile> getProfile();

  /// Kullanıcı profilini yerel depolamaya kaydeder
  Future<void> saveProfile(SkinProfile profile);
}

import '../../domain/entities/skin_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/skin_profile_model.dart';
import '../../../../core/storage/local_storage_service.dart';

/// [ProfileRepositoryImpl], [ProfileRepository] sözleşmesini yerel depolama
/// kullanarak gerçekleştiren Data katmanı uygulamasıdır.
class ProfileRepositoryImpl implements ProfileRepository {
  /// Yerel depolama anahtarı (Kutu adı: skin_profile_box)
  static const String _boxKey = 'skin_profile_box';

  final LocalStorageService _storage;

  ProfileRepositoryImpl({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService.instance;

  @override
  Future<SkinProfile> getProfile() async {
    final rawData = await _storage.read(_boxKey);
    if (rawData != null && rawData is Map<String, dynamic>) {
      return SkinProfileModel.fromJson(rawData);
    }
    // Kayıtlı profil yoksa varsayılan başlangıç profilini döndürelim ve kaydedelim
    final initialProfile = SkinProfile.initial();
    await saveProfile(initialProfile);
    return initialProfile;
  }

  @override
  Future<void> saveProfile(SkinProfile profile) async {
    final model = SkinProfileModel.fromEntity(profile);
    await _storage.write(_boxKey, model.toJson());
  }
}

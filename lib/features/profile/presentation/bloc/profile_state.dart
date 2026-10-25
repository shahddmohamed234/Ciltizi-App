import '../../domain/entities/skin_profile.dart';

/// [ProfileState] sınıfı, Profil ekranının UI durumlarını temsil eder.
abstract class ProfileState {
  const ProfileState();
}

/// Profil verileri yüklenirken gösterilen durum
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Profil verileri başarıyla yüklendiğinde veya güncellendiğinde gösterilen durum
class ProfileLoaded extends ProfileState {
  final SkinProfile profile;
  const ProfileLoaded(this.profile);
}

/// Profil yüklenirken veya kaydedilirken hata oluştuğunda gösterilen durum
class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}

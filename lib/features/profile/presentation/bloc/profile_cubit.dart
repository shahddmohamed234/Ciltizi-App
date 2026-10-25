import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/skin_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

/// [ProfileCubit] sınıfı, kullanıcı profilinin durumunu yönetir.
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(const ProfileLoading());

  /// Kayıtlı profili yükler
  Future<void> loadProfile() async {
    try {
      emit(const ProfileLoading());
      final profile = await _repository.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Profil yüklenemedi: $e'));
    }
  }

  /// Profili günceller ve kaydeder
  Future<void> updateProfile(SkinProfile updatedProfile) async {
    try {
      emit(const ProfileLoading());
      await _repository.saveProfile(updatedProfile);
      emit(ProfileLoaded(updatedProfile));
    } catch (e) {
      emit(ProfileError('Profil güncellenirken bir hata oluştu: $e'));
    }
  }
}

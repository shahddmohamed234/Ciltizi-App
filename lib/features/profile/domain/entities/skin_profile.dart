/// [SkinProfile] sınıfı, kullanıcının cilt yapısını, hedeflerini,
/// alerjilerini ve kaçınmak istediği bileşenleri temsil eden saf Domain varlığıdır.
class SkinProfile {
  /// Profilin benzersiz kimliği
  final String id;

  /// Kullanıcının cilt tipi (örn: Yağlı, Kuru, Karma, Hassas, Normal)
  final String skinType;

  /// Cilt bakım hedefleri (örn: Akne Karşıtı, Nemlendirme, Bariyer Onarımı, Yaşlanma Karşıtı)
  final List<String> skinGoals;

  /// Kullanıcının tıbbi veya bilinen alerjenleri (örn: Parfüm, Linalool, Paraben)
  final List<String> knownAllergens;

  /// Kullanıcının kişisel tercihle kaçınmak istediği içerikler (örn: Sülfat, Alkol)
  final List<String> avoidedIngredients;

  /// Profilin oluşturulma tarihi
  final DateTime createdAt;

  /// Profilin son güncellenme tarihi
  final DateTime updatedAt;

  const SkinProfile({
    required this.id,
    required this.skinType,
    required this.skinGoals,
    required this.knownAllergens,
    required this.avoidedIngredients,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Varsayılan boş/başlangıç profili üretir
  factory SkinProfile.initial() {
    final now = DateTime.now();
    return SkinProfile(
      id: 'default_profile',
      skinType: 'Karma',
      skinGoals: const ['Nemlendirme', 'Bariyer Onarımı'],
      knownAllergens: const ['Parfüm / Fragrance', 'Linalool'],
      avoidedIngredients: const ['Alcohol Denat', 'Sodium Lauryl Sulfate (SLS)'],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Profil üzerinde kopyalama ve belirli alanları güncelleme (immutable)
  SkinProfile copyWith({
    String? id,
    String? skinType,
    List<String>? skinGoals,
    List<String>? knownAllergens,
    List<String>? avoidedIngredients,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SkinProfile(
      id: id ?? this.id,
      skinType: skinType ?? this.skinType,
      skinGoals: skinGoals ?? this.skinGoals,
      knownAllergens: knownAllergens ?? this.knownAllergens,
      avoidedIngredients: avoidedIngredients ?? this.avoidedIngredients,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

import '../../domain/entities/skin_profile.dart';

/// [SkinProfileModel] sınıfı, [SkinProfile] varlığının JSON serileştirme
/// ve yerel depolama dönüşümlerini sağlayan Veri Katmanı (Data) modelidir.
class SkinProfileModel extends SkinProfile {
  const SkinProfileModel({
    required super.id,
    required super.skinType,
    required super.skinGoals,
    required super.knownAllergens,
    required super.avoidedIngredients,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Map (JSON) nesnesinden model oluşturur
  factory SkinProfileModel.fromJson(Map<String, dynamic> json) {
    return SkinProfileModel(
      id: json['id'] as String? ?? 'default_profile',
      skinType: json['skinType'] as String? ?? 'Karma',
      skinGoals: (json['skinGoals'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      knownAllergens: (json['knownAllergens'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      avoidedIngredients: (json['avoidedIngredients'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Modeli JSON formatında Map nesnesine dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skinType': skinType,
      'skinGoals': skinGoals,
      'knownAllergens': knownAllergens,
      'avoidedIngredients': avoidedIngredients,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Domain entity'sinden model üretir
  factory SkinProfileModel.fromEntity(SkinProfile entity) {
    return SkinProfileModel(
      id: entity.id,
      skinType: entity.skinType,
      skinGoals: entity.skinGoals,
      knownAllergens: entity.knownAllergens,
      avoidedIngredients: entity.avoidedIngredients,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

import '../../domain/entities/product.dart';

/// [ProductModel] sınıfı, [Product] varlığının JSON dönüşümlerini sağlayan
/// Data katmanı modelidir.
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.ingredients,
    super.rawOcrText,
    super.isVerified,
    required super.createdAt,
    required super.updatedAt,
    super.openedAt,
    super.paoMonths,
    super.expiryDate,
  });

  /// JSON verisinden ProductModel üretir
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'İsimsiz Ürün',
      brand: json['brand'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rawOcrText: json['rawOcrText'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      openedAt: json['openedAt'] != null
          ? DateTime.tryParse(json['openedAt'] as String)
          : null,
      paoMonths: json['paoMonths'] as int?,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'] as String)
          : null,
    );
  }

  /// Modeli JSON formatında Map'e dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'ingredients': ingredients,
      'rawOcrText': rawOcrText,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'openedAt': openedAt?.toIso8601String(),
      'paoMonths': paoMonths,
      'expiryDate': expiryDate != null
          ? "${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}"
          : null,
    };
  }

  /// Domain Entity nesnesinden Model üretir
  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      brand: entity.brand,
      ingredients: entity.ingredients,
      rawOcrText: entity.rawOcrText,
      isVerified: entity.isVerified,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      openedAt: entity.openedAt,
      paoMonths: entity.paoMonths,
      expiryDate: entity.expiryDate,
    );
  }
}

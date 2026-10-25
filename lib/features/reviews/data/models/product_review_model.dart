import '../../domain/entities/product_review.dart';

/// [ProductReviewModel] sınıfı, [ProductReview] varlığının JSON dönüşümlerini sağlar.
class ProductReviewModel extends ProductReview {
  const ProductReviewModel({
    required super.id,
    required super.productId,
    required super.reviewText,
    required super.sentiment,
    required super.createdAt,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      reviewText: json['reviewText'] as String? ?? '',
      sentiment: json['sentiment'] as String? ?? 'neutral',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'reviewText': reviewText,
      'sentiment': sentiment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ProductReviewModel.fromEntity(ProductReview entity) {
    return ProductReviewModel(
      id: entity.id,
      productId: entity.productId,
      reviewText: entity.reviewText,
      sentiment: entity.sentiment,
      createdAt: entity.createdAt,
    );
  }
}

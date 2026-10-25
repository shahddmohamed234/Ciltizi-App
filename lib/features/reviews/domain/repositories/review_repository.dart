import '../entities/product_review.dart';

/// [ReviewRepository] arayüzü, ürün deneyimlerinin okunması, kaydedilmesi
/// ve silinmesini yöneten Domain sözleşmesidir.
abstract class ReviewRepository {
  /// Belirli bir ürüne ait tüm deneyimleri getirir
  Future<List<ProductReview>> getReviewsByProduct(String productId);

  /// Tüm ürünlerin deneyimlerini getirir (Analiz sinyalleri için)
  Future<List<ProductReview>> getAllReviews();

  /// Yeni bir deneyim kaydeder
  Future<void> saveReview(ProductReview review);

  /// Belirtilen deneyimi siler
  Future<void> deleteReview(String id);
}

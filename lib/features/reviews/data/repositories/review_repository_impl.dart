import '../../domain/entities/product_review.dart';
import '../../domain/repositories/review_repository.dart';
import '../models/product_review_model.dart';
import '../../../../core/storage/local_storage_service.dart';

/// [ReviewRepositoryImpl], kullanıcı deneyimlerini yerel `reviews_box` kutusunda saklar.
class ReviewRepositoryImpl implements ReviewRepository {
  static const String _boxKey = 'reviews_box';

  final LocalStorageService _storage;

  ReviewRepositoryImpl({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService.instance;

  @override
  Future<List<ProductReview>> getAllReviews() async {
    final rawData = await _storage.read(_boxKey);
    if (rawData != null && rawData is List) {
      return rawData
          .map((item) => ProductReviewModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
    return [];
  }

  @override
  Future<List<ProductReview>> getReviewsByProduct(String productId) async {
    final all = await getAllReviews();
    return all.where((r) => r.productId == productId).toList();
  }

  @override
  Future<void> saveReview(ProductReview review) async {
    final all = await getAllReviews();
    final updatedList = List<ProductReview>.from(all);
    final index = updatedList.indexWhere((r) => r.id == review.id);

    if (index >= 0) {
      updatedList[index] = review;
    } else {
      updatedList.insert(0, review);
    }

    final jsonList = updatedList
        .map((r) => ProductReviewModel.fromEntity(r).toJson())
        .toList();

    await _storage.write(_boxKey, jsonList);
  }

  @override
  Future<void> deleteReview(String id) async {
    final all = await getAllReviews();
    final updatedList = all.where((r) => r.id != id).toList();

    final jsonList = updatedList
        .map((r) => ProductReviewModel.fromEntity(r).toJson())
        .toList();

    await _storage.write(_boxKey, jsonList);
  }
}

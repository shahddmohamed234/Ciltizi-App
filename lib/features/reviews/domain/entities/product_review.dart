/// [ProductReview] sınıfı, kullanıcının bir ürünle ilgili kaydettiği
/// olumlu, olumsuz veya nötr kişisel deneyim notunu temsil eden saf Domain varlığıdır.
class ProductReview {
  /// Deneyim kaydının benzersiz kimliği
  final String id;

  /// İlişkili ürünün kimliği
  final String productId;

  /// Kullanıcının girdiği deneyim/yorum notu
  final String reviewText;

  /// Deneyimin duygusu / etiketi: 'positive', 'negative', 'neutral'
  final String sentiment;

  /// Deneyimin kaydedildiği tarih
  final DateTime createdAt;

  const ProductReview({
    required this.id,
    required this.productId,
    required this.reviewText,
    required this.sentiment,
    required this.createdAt,
  });

  /// Duygu etiketinin olumsuz olup olmadığını bildirir
  bool get isNegative => sentiment == 'negative';

  /// Duygu etiketinin olumlu olup olmadığını bildirir
  bool get isPositive => sentiment == 'positive';

  /// Duygu etiketinin nötr olup olmadığını bildirir
  bool get isNeutral => sentiment == 'neutral';
}

import 'package:flutter_test/flutter_test.dart';
import 'package:ciltizi/features/analysis/domain/usecases/analyze_product_usecase.dart';
import 'package:ciltizi/features/products/domain/entities/product.dart';
import 'package:ciltizi/features/profile/domain/entities/skin_profile.dart';
import 'package:ciltizi/features/reviews/domain/entities/product_review.dart';

void main() {
  group('AnalyzeProductUseCase Testleri', () {
    const analyzer = AnalyzeProductUseCase();
    final now = DateTime.now();

    final testProfile = SkinProfile(
      id: 'p1',
      skinType: 'Karma',
      skinGoals: ['Nemlendirme'],
      knownAllergens: ['Linalool', 'Parfum'],
      avoidedIngredients: ['Alcohol Denat'],
      createdAt: now,
      updatedAt: now,
    );

    test('Alerjen eşleşmesi durumunda hasCriticalAllergen doğru olmalı ve puan düşürülmelidir', () {
      final product = Product(
        id: 'prod1',
        name: 'Alerjenli Krem',
        brand: 'Test',
        ingredients: ['Aqua', 'Glycerin', 'Linalool', 'Cetyl Alcohol'],
        createdAt: now,
        updatedAt: now,
      );

      final result = analyzer.execute(
        product: product,
        profile: testProfile,
        allProducts: [],
        allReviews: [],
      );

      expect(result.hasCriticalAllergen, isTrue);
      expect(result.matchedAllergens, contains('Linalool'));
      expect(result.score, lessThanOrEqualTo(40));
    });

    test('Alerjen ve kaçınılan maddeler çakıştığında aynı maddeye iki kez ceza verilmemelidir', () {
      final duplicateProfile = testProfile.copyWith(
        avoidedIngredients: ['Linalool'], // Aynı madde hem alerjen hem kaçınılan
      );

      final product = Product(
        id: 'prod2',
        name: 'Test Ürün',
        brand: 'Test',
        ingredients: ['Aqua', 'Linalool'],
        createdAt: now,
        updatedAt: now,
      );

      final result = analyzer.execute(
        product: product,
        profile: duplicateProfile,
        allProducts: [],
        allReviews: [],
      );

      // matchedAvoided içinde Linalool tekrar yer almamalıdır
      expect(result.matchedAllergens, contains('Linalool'));
      expect(result.matchedAvoided, isNot(contains('Linalool')));
    });

    test('Boş içerik listesinde veri yeterliliği Düşük / Eksik Veri olarak işaretlenmelidir', () {
      final emptyProduct = Product(
        id: 'prod3',
        name: 'Boş Ürün',
        brand: 'Test',
        ingredients: [],
        createdAt: now,
        updatedAt: now,
      );

      final result = analyzer.execute(
        product: emptyProduct,
        profile: testProfile,
        allProducts: [],
        allReviews: [],
      );

      expect(result.dataSufficiency, equals('Düşük / Eksik Veri'));
      expect(result.score, equals(0));
    });

    test('En az iki olumsuz deneyimde ortak bulunan içerik şüpheli sinyal üretmelidir', () {
      final badProduct1 = Product(
        id: 'bad1',
        name: 'Kötü 1',
        brand: 'Test',
        ingredients: ['Aqua', 'Dimethicone'],
        createdAt: now,
        updatedAt: now,
      );
      final badProduct2 = Product(
        id: 'bad2',
        name: 'Kötü 2',
        brand: 'Test',
        ingredients: ['Glycerin', 'Dimethicone'],
        createdAt: now,
        updatedAt: now,
      );

      final review1 = ProductReview(
        id: 'r1',
        productId: 'bad1',
        reviewText: 'Kızarıklık yaptı',
        sentiment: 'negative',
        createdAt: now,
      );
      final review2 = ProductReview(
        id: 'r2',
        productId: 'bad2',
        reviewText: 'Sivilce çıkardı',
        sentiment: 'negative',
        createdAt: now,
      );

      final candidateProduct = Product(
        id: 'cand1',
        name: 'Aday Ürün',
        brand: 'Test',
        ingredients: ['Aqua', 'Dimethicone', 'Panthenol'],
        createdAt: now,
        updatedAt: now,
      );

      final result = analyzer.execute(
        product: candidateProduct,
        profile: testProfile,
        allProducts: [badProduct1, badProduct2],
        allReviews: [review1, review2],
      );

      expect(result.suspectedIngredients, contains('Dimethicone'));
    });
  });
}

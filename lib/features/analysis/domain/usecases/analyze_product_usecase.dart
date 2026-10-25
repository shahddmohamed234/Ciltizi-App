import 'dart:math';
import 'package:ciltizi/core/utils/inci_parser.dart';
import 'package:ciltizi/features/products/domain/entities/product.dart';
import 'package:ciltizi/features/profile/domain/entities/skin_profile.dart';
import 'package:ciltizi/features/reviews/domain/entities/product_review.dart';
import '../entities/analysis_result.dart';

/// [AnalyzeProductUseCase] sınıfı, Clean Architecture kurallarına göre
/// ürünün içerik listesini, kullanıcı profilini ve geçmiş deneyim kayıtlarını
/// değerlendiren saf iş mantığı (Domain Use Case) bileşenidir.
class AnalyzeProductUseCase {
  const AnalyzeProductUseCase();

  /// Analiz işlemini yürütür ve detaylı [AnalysisResult] nesnesi üretir
  AnalysisResult execute({
    required Product product,
    required SkinProfile profile,
    required List<Product> allProducts,
    required List<ProductReview> allReviews,
  }) {
    final ingredients = product.ingredients;
    final signals = <AnalysisSignal>[];

    // --- 1. Adım: Veri Yeterliliği Kontrolü ---
    String dataSufficiency = 'Yüksek';
    String sufficiencyReason = 'Ürünün onaylanmış içerik listesi eksiksiz analiz edildi.';

    if (ingredients.isEmpty) {
      dataSufficiency = 'Düşük / Eksik Veri';
      sufficiencyReason = 'Ürüne ait onaylanmış INCI içerik listesi bulunmuyor. Analiz için lütfen içerik ekleyiniz.';
    } else if (ingredients.length < 5) {
      dataSufficiency = 'Orta';
      sufficiencyReason = 'İçerik listesi kısa olduğu için bazı bileşen etkileşimleri sınırlı değerlendirilmiş olabilir.';
    }

    // --- 2. Adım: Profil Alerjenleri Kontrolü (En Yüksek Öncelik) ---
    final matchedAllergens = InciParser.findMatches(ingredients, profile.knownAllergens);
    for (final allergen in matchedAllergens) {
      signals.add(AnalysisSignal(
        title: 'Kritik Alerjen Eşleşmesi',
        description: 'Profilinizde kayıtlı bilinen alerjen "$allergen" bu ürünün içerik listesinde bulundu.',
        severity: 'critical',
        ingredient: allergen,
      ));
    }

    // --- 3. Adım: Kaçınılacak İçerikler Kontrolü ---
    // (Aynı içerik alerjenlerde zaten cezalandırıldıysa tekrar eklenmez)
    final matchedAvoided = InciParser.findMatches(ingredients, profile.avoidedIngredients)
        .where((item) => !matchedAllergens.contains(item))
        .toList();

    for (final avoided in matchedAvoided) {
      signals.add(AnalysisSignal(
        title: 'Kaçınılacak İçerik Tespit Edildi',
        description: 'Tercihen kaçınmak istediğiniz "$avoided" bileşeni ürün içeriğinde yer alıyor.',
        severity: 'warning',
        ingredient: avoided,
      ));
    }

    // --- 4. Adım: Geçmiş Deneyimlerden Şüpheli İçerik Çıkarımı ---
    // Kural: Bir içerik, kullanıcının daha önce en az 2 farklı olumsuz deneyim bildirdiği
    // ürünlerde ortak bulunuyorsa "şüpheli sinyal" olarak değerlendirilir.
    final negativeReviews = allReviews.where((r) => r.isNegative).toList();
    final negativeProductIds = negativeReviews.map((r) => r.productId).toSet();
    final negativeProducts = allProducts.where((p) => negativeProductIds.contains(p.id) && p.id != product.id).toList();

    final suspectedIngredients = <String>[];
    if (negativeProducts.length >= 2) {
      for (final ing in ingredients) {
        // Zaten alerjen veya kaçınılan olarak işaretlendiyse çifte ceza verilmez
        if (matchedAllergens.contains(ing) || matchedAvoided.contains(ing)) continue;

        int negativeAppearanceCount = 0;
        for (final negProd in negativeProducts) {
          if (InciParser.containsIngredient(negProd.ingredients, ing)) {
            negativeAppearanceCount++;
          }
        }

        if (negativeAppearanceCount >= 2 && !suspectedIngredients.contains(ing)) {
          suspectedIngredients.add(ing);
          signals.add(AnalysisSignal(
            title: 'Olası Hassasiyet Sinyali (Kişisel Kayıt)',
            description: '"$ing" bileşeni, daha önce olumsuz deneyim belirttiğiniz en az 2 üründe ortak yer alıyor.',
            severity: 'warning',
            ingredient: ing,
          ));
        }
      }
    }

    // --- 5. Adım: Gösterge Puanı Hesabı ---
    // Formül: score = max(0, 100 - (avoidedCount * 25) - (suspectedCount * 20))
    // Alerjen varsa puan en fazla 40 ile sınırlandırılır.
    int calculatedScore = 100;
    if (ingredients.isEmpty) {
      calculatedScore = 0;
    } else {
      calculatedScore = max(0, 100 - (matchedAvoided.length * 25) - (suspectedIngredients.length * 20));
      if (matchedAllergens.isNotEmpty) {
        calculatedScore = min(calculatedScore, 35);
      }
    }

    // Eğer hiçbir olumsuz sinyal yoksa bilgilendirme sinyali ekle
    if (signals.isEmpty && ingredients.isNotEmpty) {
      signals.add(const AnalysisSignal(
        title: 'Uyumlu İçerik Profili',
        description: 'Kayıtlı alerjenleriniz veya kaçındığınız maddelerle herhangi bir çakışma tespit edilmedi.',
        severity: 'info',
      ));
    }

    return AnalysisResult(
      productId: product.id,
      matchedAllergens: matchedAllergens,
      matchedAvoided: matchedAvoided,
      suspectedIngredients: suspectedIngredients,
      signals: signals,
      dataSufficiency: dataSufficiency,
      sufficiencyReason: sufficiencyReason,
      score: calculatedScore,
      analyzedAt: DateTime.now(),
      algorithmVersion: '1.0.0',
    );
  }
}

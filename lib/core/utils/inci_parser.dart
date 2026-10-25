/// [InciParser] sınıfı, kozmetik ürün ambalajlarında bulunan INCI (International
/// Nomenclature of Cosmetic Ingredients) içerik listelerini ayrıştırma, temizleme
/// ve eşleştirme amacıyla kullanılan saf yardımcı (utility) sınıftır.
class InciParser {
  // Sınıfın örneklenmesini engellemek için private yapıcı
  const InciParser._();

  /// Ham bir metin dizesini (OCR veya kullanıcı girişi) virgül, noktalı virgül,
  /// madde imi veya yeni satırlara göre bölerek liste haline getirir.
  static List<String> parseIngredients(String rawText) {
    // Boş metin kontrolü
    if (rawText.trim().isEmpty) {
      return [];
    }

    // "Ingredients:" veya "İçindekiler:" gibi ambalaj başlıklarını temizleyelim
    final cleaned = rawText.trim()
        .replaceAll(RegExp(r'^(ingredients|içindekiler|bileşenler)\s*[:\-]\s*', caseSensitive: false, multiLine: true), '')
        .trim();

    // Yaygın ayraçlar: virgül (,), noktalı virgül (;), madde işareti (•, ·, -) veya satır başları (\n)
    final splitList = cleaned.split(RegExp(r'[,;•·\n]+'));

    final result = <String>[];
    for (final item in splitList) {
      final trimmed = item.trim();
      // Çok kısa veya anlamsız karakterleri atlayalım
      if (trimmed.length > 1) {
        // Başındaki olası başlık kelimelerini ve sonundaki nokta/boşlukları temizleyelim
        var sanitized = trimmed.replaceAll(
          RegExp(r'^(ingredients|içindekiler|bileşenler)\s*[:\-]\s*', caseSensitive: false),
          '',
        );
        sanitized = sanitized.replaceAll(RegExp(r'^[.\s]+|[.\s]+$'), '');
        if (sanitized.isNotEmpty && !result.contains(sanitized)) {
          result.add(sanitized);
        }
      }
    }

    return result;
  }

  /// Bir içerik adını karşılaştırmalar için normalize eder (küçük harfe çevirir,
  /// parantez içindeki açıklamaları ve özel karakterleri arındırır).
  static String normalize(String ingredient) {
    return ingredient
        .toLowerCase()
        // Türkçe karakter normalizasyonu (isteğe bağlı arama toleransı için)
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        // Parantezleri ve içindekileri temizleyelim (örn: "Aqua (Water)" -> "aqua")
        .replaceAll(RegExp(r'\(.*?\)'), '')
        // Birden fazla boşluğu teke indirelim
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Verilen bir içerik listesinde, hedeflenen kaçınılacak veya alerjen bir
  /// bileşenin yer alıp almadığını kontrol eder.
  static bool containsIngredient(List<String> ingredients, String target) {
    final normalizedTarget = normalize(target);
    if (normalizedTarget.isEmpty) return false;

    for (final ingredient in ingredients) {
      final normalizedIng = normalize(ingredient);
      // Tam eşleşme veya kapsama kontrolü
      if (normalizedIng == normalizedTarget ||
          normalizedIng.contains(normalizedTarget) ||
          normalizedTarget.contains(normalizedIng)) {
        return true;
      }
    }
    return false;
  }

  /// Verilen içerik listesi ile kaçınılacak maddeler kümesini karşılaştırıp
  /// eşleşen içerikleri liste olarak döndürür.
  static List<String> findMatches(List<String> ingredients, List<String> targets) {
    final matches = <String>[];
    for (final target in targets) {
      if (containsIngredient(ingredients, target)) {
        matches.add(target);
      }
    }
    return matches;
  }
}

/// [AnalysisSignal] sınıfı, analiz sonucunda ortaya çıkan her bir gerekçeli
/// uyarı veya tespit maddesini temsil eder.
class AnalysisSignal {
  /// Sinyal başlığı
  final String title;

  /// Açıklama ve gerekçe
  final String description;

  /// Kritiklik seviyesi: 'critical' (Alerjen), 'warning' (Kaçınılan/Şüpheli), 'info' (Bilgi)
  final String severity;

  /// İlişkili içerik adı
  final String? ingredient;

  const AnalysisSignal({
    required this.title,
    required this.description,
    required this.severity,
    this.ingredient,
  });

  bool get isCritical => severity == 'critical';
  bool get isWarning => severity == 'warning';
  bool get isInfo => severity == 'info';
}

/// [AnalysisResult] sınıfı, bir ürünün kullanıcının cilt profiline ve geçmiş
/// deneyimlerine göre gerçekleştirilen analizinin detaylı çıktısıdır.
class AnalysisResult {
  /// Analizin ait olduğu ürünün kimliği
  final String productId;

  /// Profilde kayıtlı alerjenlerle eşleşen içerikler
  final List<String> matchedAllergens;

  /// Profilde kaçınılmak istenen içeriklerle eşleşen maddeler
  final List<String> matchedAvoided;

  /// Kullanıcının geçmiş olumsuz deneyimlerinden kaynaklanan şüpheli içerikler
  final List<String> suspectedIngredients;

  /// Tüm gerekçeli sinyaller listesi
  final List<AnalysisSignal> signals;

  /// Veri yeterliliği etiketi: 'Yüksek', 'Orta', 'Düşük / Eksik Veri'
  final String dataSufficiency;

  /// Veri yeterliliğine dair açıklama
  final String sufficiencyReason;

  /// Hesaplanan gösterge puanı (0 - 100 arası; klinik teşhis değildir)
  final int score;

  /// Analizin yapıldığı tarih
  final DateTime analyzedAt;

  /// Algoritma sürümü
  final String algorithmVersion;

  const AnalysisResult({
    required this.productId,
    required this.matchedAllergens,
    required this.matchedAvoided,
    required this.suspectedIngredients,
    required this.signals,
    required this.dataSufficiency,
    required this.sufficiencyReason,
    required this.score,
    required this.analyzedAt,
    this.algorithmVersion = '1.0.0',
  });

  /// Kritik bir alerjen uyarısının bulunup bulunmadığını kontrol eder
  bool get hasCriticalAllergen => matchedAllergens.isNotEmpty;
}

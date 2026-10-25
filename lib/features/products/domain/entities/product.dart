/// [Product] sınıfı, kullanıcının kaydettiği veya başlangıç verisi olarak
/// gelen kozmetik ürününü temsil eden saf Domain varlığıdır.
class Product {
  /// Ürünün benzersiz kimliği (UUID veya seed ID)
  final String id;

  /// Ürün adı (örn: Hyaluronic Acid 2% + B5)
  final String name;

  /// Marka adı (örn: The Ordinary)
  final String brand;

  /// Onaylanmış INCI içerik listesi
  final List<String> ingredients;

  /// OCR ile taranmış ham metin (varsa hata ayıklama ve yeniden kontrol için)
  final String rawOcrText;

  /// İçerik listesinin kullanıcı tarafından doğrulanıp onaylandığı bilgisi
  final bool isVerified;

  /// Eklenme zamanı
  final DateTime createdAt;

  /// Son güncellenme zamanı
  final DateTime updatedAt;

  /// Ürünün açıldığı tarih (PAO hesabı için)
  final DateTime? openedAt;

  /// Açıldıktan sonra kullanım süresi (Ay cinsinden, örn: 6, 12)
  final int? paoMonths;

  /// Ambalaj üzerindeki son kullanma tarihi (YYYY-MM-DD biçiminde veya DateTime)
  final DateTime? expiryDate;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.ingredients,
    this.rawOcrText = '',
    this.isVerified = true,
    required this.createdAt,
    required this.updatedAt,
    this.openedAt,
    this.paoMonths,
    this.expiryDate,
  });

  /// PAO süresine göre ürünün süresinin dolup dolmadığını hesaplar
  bool get isPaoExpired {
    if (openedAt == null || paoMonths == null) return false;
    final expirationDate = DateTime(
      openedAt!.year,
      openedAt!.month + paoMonths!,
      openedAt!.day,
    );
    return DateTime.now().isAfter(expirationDate);
  }

  /// Son kullanma tarihine göre süresinin geçip geçmediğini hesaplar
  bool get isDateExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Kopyalama ve güncelleme fonksiyonu
  Product copyWith({
    String? id,
    String? name,
    String? brand,
    List<String>? ingredients,
    String? rawOcrText,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? openedAt,
    int? paoMonths,
    DateTime? expiryDate,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      ingredients: ingredients ?? this.ingredients,
      rawOcrText: rawOcrText ?? this.rawOcrText,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      openedAt: openedAt ?? this.openedAt,
      paoMonths: paoMonths ?? this.paoMonths,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}

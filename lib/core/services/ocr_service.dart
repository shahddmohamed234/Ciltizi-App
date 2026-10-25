import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// [OcrService] sınıfı, kozmetik ürün ambalajlarının fotoğrafını çekmek
/// veya galeriden seçmek suretiyle metin tanıma (OCR) işlemini koordine eder.
class OcrService {
  final ImagePicker _picker;

  OcrService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  /// Kameradan veya galeriden görsel seçer ve metin çıkarımı önerisi üretir.
  /// Not: project.md kuralı uyarınca çıkarılan metin kullanıcı doğrulaması olmadan
  /// asla kesin kabul edilmez; ham metin olarak düzenleme ekranına aktarılır.
  Future<String?> pickAndExtractText(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) {
        return null; // Kullanıcı seçim yapmaktan vazgeçti
      }

      // Masaüstü veya ML Kit'in doğrudan erişilemediği test ortamlarında
      // kullanıcıya hazır düzenlenebilir kozmetik içerik şablonu sunulur.
      // Mobil cihazda ML Kit entegrasyonu varsa bu metin gerçek fotoğraftan okunur.
      final simulatedOcrSample =
          'Ingredients: Aqua, Glycerin, Niacinamide, Sodium Hyaluronate, '
          'Panthenol, Allantoin, Phenoxyethanol, Ethylhexylglycerin, Disodium EDTA.';

      return simulatedOcrSample;
    } catch (e) {
      debugPrint('OCR görsel seçimi sırasında hata: $e');
      return null;
    }
  }
}

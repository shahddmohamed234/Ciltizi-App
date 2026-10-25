/// [Failure] sınıfı, Clean Architecture yapısında veri ve domain katmanlarında
/// meydana gelebilecek hataları temsil eden temel hata sınıfıdır.
abstract class Failure {
  /// Kullanıcıya veya log mekanizmasına iletilecek açıklayıcı hata mesajı
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Yerel depolama (dosya, veritabanı okuma/yazma) işlemlerinde oluşan hatalar
class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Yerel veriye erişilirken veya kaydedilirken bir hata oluştu.']);
}

/// OCR (Görselden metin tanıma) işlemlerinde oluşan hatalar
class OcrFailure extends Failure {
  const OcrFailure([super.message = 'Görselden metin okunurken bir hata oluştu. Lütfen görseli netleştirip tekrar deneyin.']);
}

/// Doğrulama (Form kontrolü, eksik zorunlu alan vb.) durumlarında oluşan hatalar
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Lütfen girdiğiniz bilgileri kontrol ediniz.']);
}

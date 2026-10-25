import '../entities/product.dart';

/// [ProductRepository] arayüzü, ürünlerin CRUD (Ekleme, Okuma, Güncelleme, Silme)
/// ve başlangıç tohum verisi işlemlerini tanımlayan Domain sözleşmesidir.
abstract class ProductRepository {
  /// Kayıtlı tüm ürünleri getirir
  Future<List<Product>> getProducts();

  /// Kimliği verilen belirli bir ürünü getirir
  Future<Product?> getProductById(String id);

  /// Yeni ürün kaydeder veya mevcut ürünü günceller
  Future<void> saveProduct(Product product);

  /// Belirtilen kimliğe sahip ürünü siler
  Future<void> deleteProduct(String id);

  /// Gerekliyse başlangıç tohum verilerini (assets/products.json) içe aktarır
  Future<void> seedInitialProductsIfNeeded();
}

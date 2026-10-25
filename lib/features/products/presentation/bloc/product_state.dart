import '../../domain/entities/product.dart';

/// [ProductState] sınıfı, Ürünler modülünün UI durumlarını temsil eder.
abstract class ProductState {
  const ProductState();
}

/// Ürünler yüklenirken
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Ürünler başarıyla yüklendiğinde
class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);
}

/// Hata oluştuğunda
class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';

/// [ProductCubit] sınıfı, ürünlerin listelenmesi, aranması, eklenmesi,
/// düzenlenmesi ve silinmesi durumlarını yönetir.
class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository) : super(const ProductLoading());

  /// Tüm ürünleri yerel depolamadan yükler
  Future<void> loadProducts() async {
    try {
      emit(const ProductLoading());
      final products = await _repository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Ürünler yüklenirken bir hata oluştu: $e'));
    }
  }

  /// Yeni ürün ekler veya mevcut olanı günceller
  Future<void> saveProduct(Product product) async {
    try {
      await _repository.saveProduct(product);
      await loadProducts(); // Listeyi tazele
    } catch (e) {
      emit(ProductError('Ürün kaydedilemedi: $e'));
    }
  }

  /// Ürünü siler
  Future<void> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      await loadProducts(); // Listeyi tazele
    } catch (e) {
      emit(ProductError('Ürün silinemedi: $e'));
    }
  }
}

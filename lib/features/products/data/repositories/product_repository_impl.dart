import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../../../../core/storage/local_storage_service.dart';

/// [ProductRepositoryImpl], ürünlerin yerel olarak JSON tabanlı saklanmasını
/// ve başlangıç tohum verilerinin idempotently (çiftleme yapmadan) yüklenmesini sağlar.
class ProductRepositoryImpl implements ProductRepository {
  /// Kutu adı: products_box
  static const String _boxKey = 'products_box';
  static const String _seedKey = 'products_seeded_v1';

  final LocalStorageService _storage;

  ProductRepositoryImpl({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService.instance;

  @override
  Future<List<Product>> getProducts() async {
    // Önce tohum verisi gerekiyorsa yükleyelim
    await seedInitialProductsIfNeeded();

    final rawData = await _storage.read(_boxKey);
    if (rawData != null && rawData is List) {
      return rawData
          .map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
    return [];
  }

  @override
  Future<Product?> getProductById(String id) async {
    final products = await getProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveProduct(Product product) async {
    final products = await getProducts();
    final index = products.indexWhere((p) => p.id == product.id);

    final updatedList = List<Product>.from(products);
    if (index >= 0) {
      // Mevcut ürünü güncelle
      updatedList[index] = product;
    } else {
      // Yeni ürünü başa ekle
      updatedList.insert(0, product);
    }

    final jsonList = updatedList
        .map((p) => ProductModel.fromEntity(p).toJson())
        .toList();

    await _storage.write(_boxKey, jsonList);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final products = await getProducts();
    final updatedList = products.where((p) => p.id != id).toList();

    final jsonList = updatedList
        .map((p) => ProductModel.fromEntity(p).toJson())
        .toList();

    await _storage.write(_boxKey, jsonList);
  }

  @override
  Future<void> seedInitialProductsIfNeeded() async {
    final isSeeded = await _storage.read(_seedKey);
    if (isSeeded == true) {
      return; // Daha önce tohumlama yapılmış, tekrar çalıştırma
    }

    try {
      final jsonString = await rootBundle.loadString('assets/products.json');
      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is List) {
        final currentProducts = await _storage.read(_boxKey);
        final currentList = currentProducts is List ? List.from(currentProducts) : [];

        for (final item in decoded) {
          final seedModel = ProductModel.fromJson(Map<String, dynamic>.from(item as Map));
          // Eğer aynı ID ile ürün zaten yoksa ekle (Kullanıcı verisini ezmeme garantisi)
          final exists = currentList.any((p) => (p as Map)['id'] == seedModel.id);
          if (!exists) {
            currentList.add(seedModel.toJson());
          }
        }

        await _storage.write(_boxKey, currentList);
      }

      // Tohumlamanın tamamlandığını işaretle
      await _storage.write(_seedKey, true);
    } catch (e) {
      // Varlık okunamadıysa sessizce devam et
    }
  }
}

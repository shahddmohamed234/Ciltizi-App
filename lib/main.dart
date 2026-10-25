import 'package:flutter/material.dart';
import 'app/app.dart';

/// Uygulamanın ana giriş noktası (Entry Point).
/// Flutter motorunu başlatır ve [CiltiziApp] kök bileşenini çalıştırır.
void main() {
  // Flutter framework bağlayıcılarının hazır olduğundan emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();

  // ciltİzi uygulamasını başlatıyoruz
  runApp(const CiltiziApp());
}

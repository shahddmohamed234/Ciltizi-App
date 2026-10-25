import 'package:flutter/material.dart';

/// [AppColors] sınıfı, ciltİzi uygulamasının ultra-lüks kozmetik ve cilt bakımı
/// görsel kimliğini oluşturan Rose & Plum (Gül & Mürdüm) paletini tanımlar.
/// Hem açık hem koyu temada kristal netliğinde kontrast ve zengin estetik sağlar.
class AppColors {
  const AppColors._();

  // --- Ana Marka Tonları (Lüks Mürdüm & Derin Şarap) ---
  /// Ana Mürdüm / Şarap tonu
  static const Color plum = Color(0xFF6B1D46);

  /// Derin gece mürdümü
  static const Color plumDark = Color(0xFF450D2B);

  /// Açık temalarda derinlik katan ultra zengin mürdüm
  static const Color plumDeep = Color(0xFF280719);

  // --- İkincil Vurgular (Lüks Gül Kurusu & Altın Pembe) ---
  /// Işıltılı Gül Pembe - Butonlar, parıltılar ve aktif durumlar
  static const Color rose = Color(0xFFE27B9E);

  /// Açık pastel gül - Vurgu arka planları ve ışıma efektleri
  static const Color roseLight = Color(0xFFF9D2E1);

  /// Çok yumuşak gül tonu - Kart ve alan aydınlatmaları
  static const Color roseSoft = Color(0xFFFDF0F5);

  /// Altın Pembe Vurgu (Rose Gold) - Lüks kozmetik hissi için
  static const Color roseGold = Color(0xFFE5A990);

  // --- Açık Tema (Light Theme) ---
  /// Açık tema ipeksi arka plan
  static const Color lightBackground = Color(0xFFFAF4F7);

  /// Açık tema saf beyaz kart yüzeyi
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Açık tema ikincil krem-gül yüzey
  static const Color lightSurfaceVariant = Color(0xFFF4E5ED);

  /// Açık tema zarif kenarlık
  static const Color lightBorder = Color(0xFFE8CFDC);

  // --- Koyu Tema (Dark Theme - Kristal Netliğinde ve Ultra Lüks) ---
  /// Koyu tema ana kadife gece zemini
  static const Color darkBackground = Color(0xFF0F030B);

  /// Koyu tema lüks kadife mürdüm kart yüzeyi
  static const Color darkSurface = Color(0xFF1C0717);

  /// Koyu tema ikincil yüzey ve giriş alanları
  static const Color darkSurfaceVariant = Color(0xFF2B0C23);

  /// Koyu tema ışıltılı gül-altın kenarlık çizgisi
  static const Color darkBorder = Color(0xFF6B254E);

  // --- Tipografi ve Metin Renkleri (Garantili Yüksek Kontrast) ---
  /// Açık tema ana başlık ve metin (Derin koyu mürdüm)
  static const Color textPrimaryLight = Color(0xFF240617);

  /// Açık tema alt başlık ve gövde metni
  static const Color textSecondaryLight = Color(0xFF7A4E66);

  /// Koyu tema ana başlık ve metin (Tam net parlak beyaz)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);

  /// Koyu tema alt başlık ve gövde metni (Kristal netliğinde parlak krem-gül)
  static const Color textSecondaryDark = Color(0xFFF0D5E5);

  // --- Durum ve Uyarı Renkleri (Her iki temada da parlak ve net) ---
  /// Kritik Alerjen Uyarısı - Parlak Yakut Kırmızısı
  static const Color alertRed = Color(0xFFFF4D4D);

  /// Kaçınılan İçerik & PAO Uyarısı - Parlak Sıcak Amber
  static const Color warningAmber = Color(0xFFFFA726);

  /// Uyumlu & Güvenli İçerik - Parlak Zümrüt Nane Yeşili
  static const Color safeGreen = Color(0xFF00E676);

  /// Bilgi ve İpucu Rengi - Safir Mavisi
  static const Color infoBlue = Color(0xFF29B6F6);

  // --- Lüks Gradyanlar (Gradients) ---
  /// Açık Tema Lüks Gül Gradyanı
  static const LinearGradient luxuryRoseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8A255B), Color(0xFF591338)],
  );

  /// Koyu Tema Derin Işıltılı Gradyan
  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF240A1D), Color(0xFF140310)],
  );

  /// Vurgu ve Buton Gradyanı
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFBA387A), Color(0xFF751647)],
  );

  /// Parıltı / İnceleme Kartı Gradyanı
  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF521437), Color(0xFF29051B)],
  );

  /// Altın Pembe Işıltı Gradyanı
  static const LinearGradient roseGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7ADC2), Color(0xFFE89A7B)],
  );
}

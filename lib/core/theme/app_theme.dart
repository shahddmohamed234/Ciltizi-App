import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// [AppTheme] sınıfı, ciltİzi uygulamasının Light ve Dark temalarını
/// lüks kozmetik estetiği, yüksek okunabilirlik ve modern Material 3
/// standartlarıyla yapılandırır.
class AppTheme {
  const AppTheme._();

  /// Açık Tema (Light Theme)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.plum,
        onPrimary: Colors.white,
        primaryContainer: AppColors.roseSoft,
        onPrimaryContainer: AppColors.plumDark,
        secondary: AppColors.rose,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.lightSurfaceVariant,
        onSecondaryContainer: AppColors.plumDark,
        surface: AppColors.lightSurface,
        onSurface: AppColors.textPrimaryLight,
        error: AppColors.alertRed,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,

      // Üst Bar Tasarımı
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.plum,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.plum,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: AppColors.plum),
      ),

      // Lüks Kart Tasarımı
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 3,
        shadowColor: AppColors.plum.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Form Giriş Alanları
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.plum, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.alertRed),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.plumDark, fontSize: 14, fontWeight: FontWeight.w600),
      ),

      // Dolgulu Ana Butonlar
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.plum,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: AppColors.plum.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Dış Çizgili Butonlar
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.plum,
          side: const BorderSide(color: AppColors.plum, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Alt Gezinme Çubuğu
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.roseSoft,
        elevation: 12,
        shadowColor: AppColors.plum.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.plum,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.plum, size: 25);
          }
          return const IconThemeData(color: AppColors.textSecondaryLight, size: 23);
        }),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1.0,
        space: 24,
      ),
    );
  }

  /// Koyu Tema (Dark Theme - Yüksek Kontrastlı, Lüks ve Okunabilir)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.rose,
        onPrimary: AppColors.darkBackground,
        primaryContainer: AppColors.darkSurfaceVariant,
        onPrimaryContainer: AppColors.roseLight,
        secondary: AppColors.roseLight,
        onSecondary: AppColors.darkBackground,
        secondaryContainer: AppColors.darkSurfaceVariant,
        onSecondaryContainer: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.alertRed,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,

      // Koyu Tema Üst Bar Tasarımı
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: AppColors.roseLight),
      ),

      // Koyu Tema Lüks Kart Tasarımı
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder, width: 1.2),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Koyu Tema Giriş Alanları (Yüksek Kontrastlı İçerik)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.rose, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.alertRed),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.roseLight, fontSize: 14, fontWeight: FontWeight.w600),
      ),

      // Koyu Tema Dolgulu Butonlar
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rose,
          foregroundColor: AppColors.darkBackground,
          elevation: 4,
          shadowColor: AppColors.rose.withValues(alpha: 0.25),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Koyu Tema Dış Çizgili Butonlar
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.roseLight,
          side: const BorderSide(color: AppColors.rose, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Koyu Tema Alt Gezinme Çubuğu (Yüksek Kontrast & Kristal Netlik)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.rose,
        elevation: 16,
        shadowColor: Colors.black.withValues(alpha: 0.6),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 0.3,
            );
          }
          return const TextStyle(
            color: AppColors.textSecondaryDark,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white, size: 26);
          }
          return IconThemeData(color: AppColors.textSecondaryDark.withValues(alpha: 0.75), size: 23);
        }),
      ),

      // Koyu Tema İletişim Kutusu (Dialog)
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.darkBorder, width: 1.4),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.textSecondaryDark,
          fontSize: 14,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1.0,
        space: 24,
      ),
    );
  }
}

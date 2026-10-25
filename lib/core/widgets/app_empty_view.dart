import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// [AppEmptyView] bileşeni, listelerde veya ekranlarda henüz veri bulunmadığında
/// kullanıcıyı bilgilendiren ve şık bir ikon/eylem butonu sunan durum bileşenidir.
class AppEmptyView extends StatelessWidget {
  /// Başlık metni (örn: "Henüz ürün eklenmemiş")
  final String title;

  /// Açıklama ve yönlendirme metni
  final String message;

  /// Gösterilecek ikon
  final IconData icon;

  /// İsteğe bağlı eylem butonu metni (örn: "Ürün Ekle")
  final String? actionLabel;

  /// Eylem butonuna basıldığında çalışacak geri çağırma fonksiyonu
  final VoidCallback? onAction;

  const AppEmptyView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.spa_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // İkonu saran yumuşak dairesel mürdüm/gül kabarcığı
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.roseSoft,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.roseLight,
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                size: 42,
                color: isDark ? AppColors.roseLight : AppColors.plum,
              ),
            ),
            const SizedBox(height: 20),

            // Durum Başlığı
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.plum,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),

            // Açıklama metni
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),

            // İsteğe bağlı aksiyon butonu
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 20),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

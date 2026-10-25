import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/app_strings.dart';

/// [AppErrorView] bileşeni, bir işlem sırasında hata oluştuğunda
/// kullanıcıya anlaşılır mesaj ileten ve tekrar deneme olanağı sunan bileşendir.
class AppErrorView extends StatelessWidget {
  /// Başlık
  final String? title;

  /// Hata mesajı
  final String message;

  /// Tekrar dene butonuna basıldığında tetiklenecek fonksiyon
  final VoidCallback? onRetry;

  const AppErrorView({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);
    final displayTitle = title ?? strings.somethingWentWrong;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hata ikonu
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.alertRed.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.alertRed.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 38,
                color: AppColors.alertRed,
              ),
            ),
            const SizedBox(height: 20),

            // Hata Başlığı
            Text(
              displayTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.plumDark,
              ),
            ),
            const SizedBox(height: 8),

            // Hata Açıklaması
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

            // Tekrar Dene butonu
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(strings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

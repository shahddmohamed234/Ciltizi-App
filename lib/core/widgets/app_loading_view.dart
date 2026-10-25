import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/app_strings.dart';

/// [AppLoadingView] bileşeni, veri yüklenirken gösterilen animasyonlu ve
/// temaya uyumlu yükleme göstergesidir.
class AppLoadingView extends StatelessWidget {
  /// Yükleme sırasında gösterilecek açıklama metni
  final String? message;

  const AppLoadingView({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);
    final displayMessage = message ?? (strings.isTr ? 'Yükleniyor...' : 'Loading...');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mürdüm veya Gül tonunda dairesel ilerleme çubuğu
            SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                color: isDark ? AppColors.rose : AppColors.plum,
                backgroundColor: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.roseSoft,
              ),
            ),
            const SizedBox(height: 16),

            // Yükleme metni
            Text(
              displayMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

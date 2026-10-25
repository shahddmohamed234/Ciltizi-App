import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../../domain/entities/app_settings.dart';
import '../bloc/settings_cubit.dart';

/// [SettingsScreen] sınıfı, uygulamanın tema seçimini (System, Light, Dark)
/// ve dil ayarlarını (Türkçe, English) dinamik olarak yöneten ekrandır.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settingsTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            children: [
              // 1. Tema Seçimi Bölümü
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.rose.withValues(alpha: isDark ? 0.25 : 0.15),
                          ),
                          child: Icon(
                            Icons.palette_outlined,
                            color: isDark ? AppColors.roseLight : AppColors.plum,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          strings.appearanceHeader,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Sistem Teması Kartı
                    _buildThemeOptionTile(
                      context: context,
                      title: strings.systemThemeTitle,
                      description: strings.systemThemeDesc,
                      icon: Icons.brightness_auto_rounded,
                      isSelected: settings.themeMode == ThemeMode.system,
                      onTap: () => context.read<SettingsCubit>().setThemeMode(ThemeMode.system),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),

                    // Açık Tema Kartı
                    _buildThemeOptionTile(
                      context: context,
                      title: strings.lightThemeTitle,
                      description: strings.lightThemeDesc,
                      icon: Icons.light_mode_rounded,
                      isSelected: settings.themeMode == ThemeMode.light,
                      onTap: () => context.read<SettingsCubit>().setThemeMode(ThemeMode.light),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),

                    // Koyu Tema Kartı
                    _buildThemeOptionTile(
                      context: context,
                      title: strings.darkThemeTitle,
                      description: strings.darkThemeDesc,
                      icon: Icons.dark_mode_rounded,
                      isSelected: settings.themeMode == ThemeMode.dark,
                      onTap: () => context.read<SettingsCubit>().setThemeMode(ThemeMode.dark),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Dil Seçimi Bölümü (Language Selection)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.rose.withValues(alpha: isDark ? 0.25 : 0.15),
                          ),
                          child: Icon(
                            Icons.language_rounded,
                            color: isDark ? AppColors.roseLight : AppColors.plum,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          strings.languageHeader,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Türkçe Seçeneği
                    _buildLanguageOptionTile(
                      context: context,
                      title: strings.turkishTitle,
                      subtitle: strings.turkishDesc,
                      flag: '🇹🇷',
                      isSelected: settings.languageCode == 'tr',
                      onTap: () => context.read<SettingsCubit>().setLanguage('tr'),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),

                    // English Seçeneği
                    _buildLanguageOptionTile(
                      context: context,
                      title: strings.englishTitle,
                      subtitle: strings.englishDesc,
                      flag: '🇬🇧',
                      isSelected: settings.languageCode == 'en',
                      onTap: () => context.read<SettingsCubit>().setLanguage('en'),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Gizlilik ve Güvenlik Kartı
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.safeGreen.withValues(alpha: isDark ? 0.25 : 0.15),
                          ),
                          child: const Icon(Icons.shield_outlined, color: AppColors.safeGreen, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          strings.privacyHeader,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      strings.privacyDesc,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Uygulama Hakkında Kartı
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.rose.withValues(alpha: isDark ? 0.25 : 0.15),
                          ),
                          child: Icon(
                            Icons.spa_outlined,
                            color: isDark ? AppColors.roseLight : AppColors.plum,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          strings.aboutHeader,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      strings.aboutDesc,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Özel Tema Seçim Kartı
  Widget _buildThemeOptionTile({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final activeBorderColor = AppColors.rose;
    final inactiveBorderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.rose.withValues(alpha: 0.15) : AppColors.roseSoft)
              : (isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeBorderColor : inactiveBorderColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? AppColors.rose
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.rose, size: 22)
            else
              Icon(
                Icons.radio_button_unchecked_rounded,
                size: 22,
                color: isDark ? AppColors.roseLight.withValues(alpha: 0.4) : AppColors.plum.withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    );
  }

  /// Özel Dil Seçim Kartı (Türkçe / English)
  Widget _buildLanguageOptionTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final activeBorderColor = AppColors.rose;
    final inactiveBorderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.rose.withValues(alpha: 0.18) : AppColors.roseSoft)
              : (isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeBorderColor : inactiveBorderColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.darkSurface : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.rose : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Center(
                child: Text(
                  flag,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.rose, size: 22)
            else
              Icon(
                Icons.radio_button_unchecked_rounded,
                size: 22,
                color: isDark ? AppColors.roseLight.withValues(alpha: 0.4) : AppColors.plum.withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    );
  }
}

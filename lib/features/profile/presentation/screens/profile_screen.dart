import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../domain/entities/skin_profile.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

/// [ProfileScreen] sınıfı, kullanıcının cilt tipini, bakım hedeflerini,
/// bilinen alerjenlerini ve kaçınmak istediği içerikleri modern, lüks ve
/// yüksek kontrastlı bir arayüzde yönetmesini sağlar.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedSkinType = 'Karma';
  List<String> _selectedGoals = [];
  List<String> _allergens = [];
  List<String> _avoided = [];

  final TextEditingController _allergenController = TextEditingController();
  final TextEditingController _avoidedController = TextEditingController();

  final List<String> _availableSkinTypes = const ['Kuru', 'Yağlı', 'Karma', 'Hassas', 'Normal'];

  final List<String> _availableGoals = const [
    'Nemlendirme',
    'Bariyer Onarımı',
    'Akne Karşıtı',
    'Yaşlanma Karşıtı',
    'Aydınlatma',
    'Gözenek Sıkılaştırma',
    'Kızarıklık Yatıştırma',
  ];

  static const List<String> _suggestedAllergens = [
    'Parfüm',
    'Linalool',
    'Limonene',
    'Citronellol',
    'Geraniol',
    'Benzil Alkol',
    'Nikel',
    'Esansiyel Yağlar',
    'Formaldehit',
  ];

  static const List<String> _suggestedAvoided = [
    'Sülfat (SLS/SLES)',
    'Paraben',
    'Kurutucu Alkol',
    'Silikon',
    'Mineral Yağ',
    'Yapay Renklendirici',
    'Ftalat',
    'BHT / BHA',
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileLoaded) {
      _initFromProfile(state.profile);
    }
  }

  void _initFromProfile(SkinProfile profile) {
    _selectedSkinType = profile.skinType;
    _selectedGoals = List.from(profile.skinGoals);
    _allergens = List.from(profile.knownAllergens);
    _avoided = List.from(profile.avoidedIngredients);
  }

  @override
  void dispose() {
    _allergenController.dispose();
    _avoidedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);

    return Scaffold(
      // Üst Barda Tekrarlanan Tik İşareti Kaldırıldı (Kullanıcı Talebi)
      appBar: AppBar(
        title: Text(strings.profileTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _initFromProfile(state.profile);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return AppLoadingView(message: strings.loadingProfile);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Profil Başlık Kartı
                _buildProfileHeaderCard(context, isDark, strings),
                const SizedBox(height: 16),

                // 2. Cilt Tipi Seçimi Kartı
                _buildSkinTypeCard(context, isDark, strings),
                const SizedBox(height: 16),

                // 3. Bakım Hedefleri Kartı
                _buildSkinGoalsCard(context, isDark, strings),
                const SizedBox(height: 16),

                // 4. Bilinen Alerjenler (Öneri Listesi + Özel Giriş)
                _buildAllergensCard(context, isDark, strings),
                const SizedBox(height: 16),

                // 5. Kaçınılacak İçerikler (Öneri Listesi + Özel Giriş)
                _buildAvoidedCard(context, isDark, strings),
                const SizedBox(height: 24),

                // Profili Güncelle Ana Butonu
                ElevatedButton.icon(
                  onPressed: () => _saveProfile(strings),
                  icon: const Icon(Icons.check_circle_rounded, size: 22),
                  label: Text(strings.updateProfileBtn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Profil Başlık Kartı
  Widget _buildProfileHeaderCard(BuildContext context, bool isDark, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: isDark ? AppColors.darkCardGradient : AppColors.heroCardGradient,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.rose.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.rose.withValues(alpha: 0.25),
              border: Border.all(color: AppColors.roseLight, width: 2),
            ),
            child: const Icon(
              Icons.face_retouching_natural_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.profileHeaderTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.profileHeaderSubtitle,
                  style: const TextStyle(
                    color: AppColors.roseLight,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Cilt Tipi Seçimi Kartı
  Widget _buildSkinTypeCard(BuildContext context, bool isDark, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.skinTypeTitle,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableSkinTypes.map((type) {
              final isSelected = _selectedSkinType == type;
              return ChoiceChip(
                label: Text(strings.translateSkinType(type)),
                selected: isSelected,
                selectedColor: AppColors.rose,
                backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.rose
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedSkinType = type);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Cilt Bakım Hedefleri Kartı
  Widget _buildSkinGoalsCard(BuildContext context, bool isDark, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.skinGoalsTitle,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableGoals.map((goal) {
              final isSelected = _selectedGoals.contains(goal);
              return FilterChip(
                label: Text(strings.translateGoal(goal)),
                selected: isSelected,
                selectedColor: isDark ? AppColors.rose.withValues(alpha: 0.3) : AppColors.roseSoft,
                checkmarkColor: isDark ? AppColors.roseLight : AppColors.plum,
                backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                labelStyle: TextStyle(
                  color: isSelected
                      ? (isDark ? AppColors.roseLight : AppColors.plum)
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.rose
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedGoals.add(goal);
                    } else {
                      _selectedGoals.remove(goal);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Bilinen Alerjenler Kartı (Hızlı Öneri Listesi + Özel Giriş)
  Widget _buildAllergensCard(BuildContext context, bool isDark, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.alertRed.withValues(alpha: isDark ? 0.45 : 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 12,
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.alertRed.withValues(alpha: 0.18),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: AppColors.alertRed, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  strings.allergensTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.alertRed),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            strings.allergensDesc,
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 14),

          // 1. Sık Tercih Edilen Öneriler Başlığı
          Text(
            strings.quickAllergenSuggestions,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.roseLight : AppColors.plum,
            ),
          ),
          const SizedBox(height: 8),

          // Öneri Çipleri (Tek Dokunuşla Ekle/Çıkar)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedAllergens.map((alg) {
              final isSelected = _allergens.contains(alg);
              return FilterChip(
                label: Text(strings.translateSuggestedAllergen(alg)),
                selected: isSelected,
                selectedColor: AppColors.alertRed.withValues(alpha: isDark ? 0.3 : 0.15),
                checkmarkColor: AppColors.alertRed,
                backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.alertRed
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.alertRed
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _allergens.add(alg);
                    } else {
                      _allergens.remove(alg);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 2. Kullanıcının Kendi Yazabileceği Özel Giriş Alanı
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _allergenController,
                  decoration: InputDecoration(
                    hintText: strings.customAllergenHint,
                    prefixIcon: const Icon(Icons.edit_note_rounded, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final text = _allergenController.text.trim();
                  if (text.isNotEmpty && !_allergens.contains(text)) {
                    setState(() => _allergens.add(text));
                    _allergenController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.alertRed,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                ),
                child: Text(strings.addBtn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          ),

          // Seçili Alerjenler Özeti
          if (_allergens.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              '${strings.savedAllergensHeader} (${_allergens.length}):',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allergens.map((alg) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.alertRed.withValues(alpha: isDark ? 0.25 : 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        strings.translateSuggestedAllergen(alg),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.alertRed,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() => _allergens.remove(alg)),
                        child: const Icon(Icons.close_rounded, size: 16, color: AppColors.alertRed),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Kaçınılacak Maddeler Kartı (Hızlı Öneri Listesi + Özel Giriş)
  Widget _buildAvoidedCard(BuildContext context, bool isDark, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.warningAmber.withValues(alpha: isDark ? 0.45 : 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 12,
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warningAmber.withValues(alpha: 0.18),
                ),
                child: const Icon(Icons.block_rounded, color: AppColors.warningAmber, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  strings.avoidedTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.warningAmber),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            strings.avoidedDesc,
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 14),

          // 1. Sık Tercih Edilen Kaçınılanlar Başlığı
          Text(
            strings.quickAvoidedSuggestions,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.roseLight : AppColors.plum,
            ),
          ),
          const SizedBox(height: 8),

          // Öneri Çipleri (Tek Dokunuşla Ekle/Çıkar)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedAvoided.map((item) {
              final isSelected = _avoided.contains(item);
              return FilterChip(
                label: Text(strings.translateSuggestedAvoided(item)),
                selected: isSelected,
                selectedColor: AppColors.warningAmber.withValues(alpha: isDark ? 0.3 : 0.15),
                checkmarkColor: AppColors.warningAmber,
                backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.warningAmber
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.warningAmber
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _avoided.add(item);
                    } else {
                      _avoided.remove(item);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 2. Kullanıcının Kendi Yazabileceği Özel Giriş Alanı
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _avoidedController,
                  decoration: InputDecoration(
                    hintText: strings.customAvoidedHint,
                    prefixIcon: const Icon(Icons.edit_note_rounded, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final text = _avoidedController.text.trim();
                  if (text.isNotEmpty && !_avoided.contains(text)) {
                    setState(() => _avoided.add(text));
                    _avoidedController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warningAmber,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                ),
                child: Text(strings.addBtn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          ),

          // Seçili Kaçınılacak Maddeler Özeti
          if (_avoided.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              '${strings.savedAvoidedHeader} (${_avoided.length}):',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _avoided.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmber.withValues(alpha: isDark ? 0.25 : 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warningAmber.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        strings.translateSuggestedAvoided(item),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.warningAmber,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() => _avoided.remove(item)),
                        child: const Icon(Icons.close_rounded, size: 16, color: AppColors.warningAmber),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  void _saveProfile(AppStrings strings) {
    final current = context.read<ProfileCubit>().state;
    final currentProfile = current is ProfileLoaded ? current.profile : SkinProfile.initial();

    final updated = currentProfile.copyWith(
      skinType: _selectedSkinType,
      skinGoals: _selectedGoals,
      knownAllergens: _allergens,
      avoidedIngredients: _avoided,
      updatedAt: DateTime.now(),
    );

    context.read<ProfileCubit>().updateProfile(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.profileSavedSuccess),
        backgroundColor: AppColors.safeGreen,
      ),
    );
  }
}

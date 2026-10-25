import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../products/data/repositories/product_repository_impl.dart';
import '../../../products/domain/entities/product.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../../reviews/data/repositories/review_repository_impl.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/usecases/analyze_product_usecase.dart';

/// [AnalysisResultScreen] sınıfı, ürünün onaylanmış INCI içerik listesinin
/// kullanıcının profili, alerjenleri ve geçmiş deneyim kayıtlarıyla
/// karşılaştırılarak oluşturulan detaylı analiz raporunu lüks bir tasarımda sunar.
class AnalysisResultScreen extends StatefulWidget {
  final Product product;

  const AnalysisResultScreen({super.key, required this.product});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  final AnalyzeProductUseCase _analyzer = const AnalyzeProductUseCase();
  AnalysisResult? _result;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    setState(() => _isLoading = true);

    final profileState = context.read<ProfileCubit>().state;
    final profile = profileState is ProfileLoaded ? profileState.profile : null;

    if (profile == null) {
      setState(() => _isLoading = false);
      return;
    }

    final allProducts = await ProductRepositoryImpl().getProducts();
    final allReviews = await ReviewRepositoryImpl().getAllReviews();

    final result = _analyzer.execute(
      product: widget.product,
      profile: profile,
      allProducts: allProducts,
      allReviews: allReviews,
    );

    if (mounted) {
      setState(() {
        _result = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.analysisReportTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _result == null
              ? Center(child: Text(strings.analysisFailed))
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- 1. Kural: Kritik Alerjen Uyarısı (Puandan Önce En Üstte) ---
                      if (_result!.hasCriticalAllergen)
                        _buildLuxeAllergenBanner(context, _result!, isDark, strings),

                      const SizedBox(height: 16),

                      // --- 2. Lüks Puan ve Veri Yeterliliği Kartı ---
                      _buildLuxeScoreCard(context, _result!, isDark, strings),

                      const SizedBox(height: 22),

                      // --- 3. Gerekçeli Analiz Bulguları ve Sinyalleri ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${strings.reasonedFindingsTitle} (${_result!.signals.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceVariant : AppColors.roseSoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'v${_result!.algorithmVersion}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.roseLight : AppColors.plum,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ..._result!.signals.map((sig) => _buildLuxeSignalCard(context, sig, isDark, strings)),

                      const SizedBox(height: 24),

                      // --- 4. Tıbbi Sınırlar ve Yasal Uyarı Metni ---
                      _buildLuxeDisclaimer(context, isDark, strings),
                    ],
                  ),
                ),
    );
  }

  /// Kritik Alerjen Bannerı (Lüks, dikkat çekici ve tam okunabilir)
  Widget _buildLuxeAllergenBanner(BuildContext context, AnalysisResult result, bool isDark, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF38080C) : const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.alertRed, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.alertRed.withValues(alpha: isDark ? 0.3 : 0.15),
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
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.alertRed,
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  strings.criticalAllergenDetected,
                  style: const TextStyle(
                    color: AppColors.alertRed,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            strings.isTr
                ? 'Profilinizde kayıtlı olan alerjen maddeler ürün içeriğinde bulundu:\n'
                  '• ${result.matchedAllergens.join(", ")}\n\n'
                  'Bu uyarı, uygunluk puanından ve önceki olumlu deneyimlerden önceliklidir.'
                : 'Known allergens from your profile were found in this formula:\n'
                  '• ${result.matchedAllergens.map((a) => strings.translateSuggestedAllergen(a)).join(", ")}\n\n'
                  'This warning takes precedence over match scores and previous positive experiences.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: isDark ? Colors.white : const Color(0xFF8A1414),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Lüks Gösterge Puanı Kartı
  Widget _buildLuxeScoreCard(BuildContext context, AnalysisResult result, bool isDark, AppStrings strings) {
    Color scoreColor = AppColors.safeGreen;
    String scoreStatus = strings.isTr ? 'Uyumlu İçerik' : 'Compatible Formula';

    if (result.score < 50) {
      scoreColor = AppColors.alertRed;
      scoreStatus = strings.isTr ? 'Yüksek Risk / Uyumsuz' : 'High Risk / Incompatible';
    } else if (result.score < 75) {
      scoreColor = AppColors.warningAmber;
      scoreStatus = strings.isTr ? 'Dikkat Gerektirebilir' : 'Requires Caution';
    }

    final sufficiencyLabel = strings.isTr
        ? result.dataSufficiency
        : (result.dataSufficiency == 'Yüksek'
            ? strings.dataSufficiencyHigh
            : (result.dataSufficiency == 'Orta'
                ? strings.dataSufficiencyMedium
                : strings.dataSufficiencyLow));

    final sufficiencyReason = strings.isTr
        ? result.sufficiencyReason
        : (result.dataSufficiency == 'Yüksek'
            ? strings.dataSufficiencyFullMsg
            : (result.dataSufficiency == 'Orta'
                ? strings.dataSufficiencyShortMsg
                : strings.dataSufficiencyEmptyMsg));

    return Container(
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
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Işıltılı Puan Dairesi
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scoreColor.withValues(alpha: isDark ? 0.2 : 0.12),
                  border: Border.all(color: scoreColor, width: 3.5),
                  boxShadow: [
                    BoxShadow(
                      color: scoreColor.withValues(alpha: 0.25),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${result.score}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: scoreColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),

              // Puan Başlığı ve Veri Yeterliliği
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.profileScoreTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scoreStatus,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: scoreColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Veri Yeterlilik Rozeti
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 13,
                            color: isDark ? AppColors.roseLight : AppColors.plum,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${strings.dataSufficiencyTitle}: $sufficiencyLabel',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Text(
            sufficiencyReason,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  /// Lüks Sinyal Kartı
  Widget _buildLuxeSignalCard(BuildContext context, AnalysisSignal signal, bool isDark, AppStrings strings) {
    Color cardColor = AppColors.infoBlue;
    IconData icon = Icons.info_outline;

    if (signal.isCritical) {
      cardColor = AppColors.alertRed;
      icon = Icons.cancel_outlined;
    } else if (signal.isWarning) {
      cardColor = AppColors.warningAmber;
      icon = Icons.warning_amber_rounded;
    } else if (signal.severity == 'info') {
      cardColor = AppColors.safeGreen;
      icon = Icons.check_circle_outline;
    }

    final signalTitle = strings.translateSignalTitle(signal.title, signal.severity);
    final signalDesc = strings.translateSignalDesc(signal.description, signal.ingredient ?? '', signal.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.2,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sol Vurgu Şeridi
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: cardColor, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            signalTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: cardColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            signalDesc,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tıbbi Sorumluluk Reddi (Yüksek Okunabilirlik)
  Widget _buildLuxeDisclaimer(BuildContext context, bool isDark, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            size: 22,
            color: isDark ? AppColors.roseLight : AppColors.plum,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              strings.legalDisclaimer,
              style: TextStyle(
                fontSize: 12,
                height: 1.45,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../analysis/presentation/screens/analysis_result_screen.dart';
import '../../../reviews/data/repositories/review_repository_impl.dart';
import '../../../reviews/domain/entities/product_review.dart';
import '../../../reviews/domain/repositories/review_repository.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';
import 'add_edit_product_screen.dart';

/// [ProductDetailScreen] sınıfı, kozmetik ürünün detaylarını, doğrulanmış INCI
/// içeriklerini, kullanım sürelerini (PAO/SKT) ve kullanıcı deneyimlerini
/// lüks ve ferah bir arayüzde sunar.
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ReviewRepository _reviewRepo = ReviewRepositoryImpl();
  List<ProductReview> _reviews = [];
  bool _isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoadingReviews = true);
    final reviews = await _reviewRepo.getReviewsByProduct(widget.productId);
    if (mounted) {
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        Product? product;
        if (state is ProductLoaded) {
          try {
            product = state.products.firstWhere((p) => p.id == widget.productId);
          } catch (_) {
            product = null;
          }
        }

        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: Text(strings.productDetail)),
            body: Center(child: Text(strings.productNotFound)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              strings.translateProductName(product.name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.edit_note_rounded,
                  size: 26,
                  color: isDark ? AppColors.roseLight : AppColors.plum,
                ),
                tooltip: strings.editProduct,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditProductScreen(productToEdit: product),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.alertRed),
                tooltip: strings.deleteProduct,
                onPressed: () => _confirmDeleteProduct(context, product!, strings),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Ürün Hero Kartı (Marka, Ad, Durum)
                _buildProductHeroCard(context, product, isDark, strings),
                const SizedBox(height: 16),

                // 2. Kişiselleştirilmiş Analiz Başlatma CTA Kartı (Lüks Gradyanlı)
                _buildAnalysisCtaCard(context, product, isDark, strings),
                const SizedBox(height: 20),

                // 3. Kullanım ve Süre Bilgisi (Yazı Taşmalarını Engelleyen Geniş Tasarım)
                _buildSpaciousDatesCard(context, product, isDark, strings),
                const SizedBox(height: 20),

                // 4. INCI İçerik Listesi Bölümü
                _buildIngredientsSection(context, product, isDark, strings),
                const SizedBox(height: 24),

                // 5. Kullanıcı Deneyimleri Bölümü
                _buildReviewsSection(context, product, isDark, strings),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Ürün Başlık Hero Kartı
  Widget _buildProductHeroCard(BuildContext context, Product product, bool isDark, AppStrings strings) {
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
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceVariant : AppColors.roseSoft,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.roseLight,
                  ),
                ),
                child: Text(
                  product.brand.isNotEmpty ? product.brand.toUpperCase() : strings.cosmeticFallback,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.roseLight : AppColors.plum,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const Spacer(),
              if (product.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.safeGreen.withValues(alpha: isDark ? 0.22 : 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.safeGreen.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, size: 14, color: AppColors.safeGreen),
                      const SizedBox(width: 5),
                      Text(
                        strings.verifiedIngredient,
                        style: const TextStyle(
                          color: AppColors.safeGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            strings.translateProductName(product.name),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              letterSpacing: -0.4,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  /// Kişiselleştirilmiş Analiz Başlatma Kartı (Yüksek Kontrast ve Lüks)
  Widget _buildAnalysisCtaCard(BuildContext context, Product product, bool isDark, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF45112F), Color(0xFF230718)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B1D46), Color(0xFF48102E)],
              ),
        border: Border.all(
          color: isDark ? AppColors.rose.withValues(alpha: 0.4) : AppColors.roseLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.plum.withValues(alpha: isDark ? 0.4 : 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.roseLight, size: 24),
              const SizedBox(width: 10),
              Text(
                strings.ctaAnalysisTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            strings.ctaAnalysisDesc,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.roseLight,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rose,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnalysisResultScreen(product: product),
                  ),
                );
              },
              icon: const Icon(Icons.flash_on_rounded, size: 20),
              label: Text(
                strings.ctaAnalyzeNow,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Ferah ve Satır Taşması Yapmayan Kullanım & Tarih Kartı
  Widget _buildSpaciousDatesCard(BuildContext context, Product product, bool isDark, AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 20,
                color: isDark ? AppColors.roseLight : AppColors.plum,
              ),
              const SizedBox(width: 8),
              Text(
                strings.usageTracking,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 1. PAO Satırı (Tam Genişlik, Asla Taşmaz)
          _buildDateRow(
            icon: Icons.timelapse_rounded,
            title: strings.paoFullTitle,
            value: product.paoMonths != null ? '${product.paoMonths} ${strings.months}' : strings.notSpecified,
            isExpired: product.isPaoExpired,
            isDark: isDark,
            strings: strings,
          ),
          const Divider(height: 20),

          // 2. Açılış Tarihi Satırı
          _buildDateRow(
            icon: Icons.lock_open_rounded,
            title: strings.openedDate,
            value: product.openedAt != null
                ? '${product.openedAt!.day}.${product.openedAt!.month}.${product.openedAt!.year}'
                : strings.notSpecified,
            isExpired: false,
            isDark: isDark,
            strings: strings,
          ),
          const Divider(height: 20),

          // 3. Son Kullanma Tarihi (SKT) Satırı
          _buildDateRow(
            icon: Icons.event_busy_rounded,
            title: strings.expiryDate,
            value: product.expiryDate != null
                ? '${product.expiryDate!.day}.${product.expiryDate!.month}.${product.expiryDate!.year}'
                : strings.notSpecified,
            isExpired: product.isDateExpired,
            isDark: isDark,
            strings: strings,
          ),
        ],
      ),
    );
  }

  /// Tarih Satırı Tekil Tasarımı
  Widget _buildDateRow({
    required IconData icon,
    required String title,
    required String value,
    required bool isExpired,
    required bool isDark,
    required AppStrings strings,
  }) {
    final valueColor = isExpired
        ? AppColors.alertRed
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isExpired
                ? AppColors.alertRed.withValues(alpha: isDark ? 0.25 : 0.12)
                : (isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isExpired
                ? AppColors.alertRed
                : (isDark ? AppColors.roseLight : AppColors.plum),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isExpired ? '$value ${strings.expiredSuffix}' : value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// İçerik Listesi Bölümü
  Widget _buildIngredientsSection(BuildContext context, Product product, bool isDark, AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              strings.inciListTitle,
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
                '${product.ingredients.length} ${strings.items}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.roseLight : AppColors.plum,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (product.ingredients.isEmpty)
          Text(strings.noIngredientsYet)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.ingredients.map((ing) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Text(
                  ing,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  /// Kullanıcı Deneyimleri Bölümü
  Widget _buildReviewsSection(BuildContext context, Product product, bool isDark, AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${strings.myReviewsTitle} (${_reviews.length})',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showAddReviewDialog(context, product, strings),
              icon: const Icon(Icons.rate_review_rounded, size: 16),
              label: Text(strings.addReview, style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoadingReviews)
          const Center(child: CircularProgressIndicator())
        else if (_reviews.isEmpty)
          AppEmptyView(
            icon: Icons.rate_review_outlined,
            title: strings.noReviewsTitle,
            message: strings.noReviewsDesc,
          )
        else
          ..._reviews.map((rev) => _buildLuxuryReviewCard(context, rev, isDark, strings)),
      ],
    );
  }

  /// Lüks Deneyim Kartı (Silme Butonlu)
  Widget _buildLuxuryReviewCard(BuildContext context, ProductReview review, bool isDark, AppStrings strings) {
    Color sentimentColor = isDark ? AppColors.roseLight : AppColors.textSecondaryLight;
    String sentimentText = strings.neutralEffect;
    IconData sentimentIcon = Icons.sentiment_neutral_rounded;

    if (review.isPositive) {
      sentimentColor = AppColors.safeGreen;
      sentimentText = strings.positiveEffect;
      sentimentIcon = Icons.sentiment_satisfied_alt_rounded;
    } else if (review.isNegative) {
      sentimentColor = AppColors.alertRed;
      sentimentText = strings.negativeEffect;
      sentimentIcon = Icons.sentiment_very_dissatisfied_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: sentimentColor.withValues(alpha: isDark ? 0.22 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: sentimentColor.withValues(alpha: 0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(sentimentIcon, size: 16, color: sentimentColor),
                    const SizedBox(width: 6),
                    Text(
                      sentimentText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: sentimentColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${review.createdAt.day}.${review.createdAt.month}.${review.createdAt.year}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: 4),
              // Yorum Silme Butonu
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.alertRed),
                tooltip: strings.deleteConfirmTitle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _confirmDeleteReview(context, review, strings),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.reviewText,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  /// Deneyim Ekleme İletişim Kutusu (Taşmayan ve Geniş Tasarım)
  void _showAddReviewDialog(BuildContext context, Product product, AppStrings strings) {
    final noteController = TextEditingController();
    String selectedSentiment = 'positive';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              title: Text(strings.addReviewTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Taşmayan ve Ferah Özel Duygu Seçim Butonları
                      Row(
                        children: [
                          Expanded(
                            child: _buildSentimentChoiceTile(
                              label: strings.positive,
                              icon: Icons.sentiment_satisfied_alt_rounded,
                              activeColor: AppColors.safeGreen,
                              isSelected: selectedSentiment == 'positive',
                              onTap: () => setDialogState(() => selectedSentiment = 'positive'),
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildSentimentChoiceTile(
                              label: strings.neutral,
                              icon: Icons.sentiment_neutral_rounded,
                              activeColor: isDark ? AppColors.rose : AppColors.plum,
                              isSelected: selectedSentiment == 'neutral',
                              onTap: () => setDialogState(() => selectedSentiment = 'neutral'),
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildSentimentChoiceTile(
                              label: strings.negative,
                              icon: Icons.sentiment_very_dissatisfied_rounded,
                              activeColor: AppColors.alertRed,
                              isSelected: selectedSentiment == 'negative',
                              onTap: () => setDialogState(() => selectedSentiment = 'negative'),
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: noteController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: strings.reviewNoteLabel,
                          hintText: strings.reviewNoteHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: Text(strings.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (noteController.text.trim().isEmpty) return;

                    final newReview = ProductReview(
                      id: const Uuid().v4(),
                      productId: product.id,
                      reviewText: noteController.text.trim(),
                      sentiment: selectedSentiment,
                      createdAt: DateTime.now(),
                    );

                    await _reviewRepo.saveReview(newReview);
                    if (dialogCtx.mounted) {
                      Navigator.pop(dialogCtx);
                    }
                    if (mounted) {
                      _loadReviews();
                    }
                  },
                  child: Text(strings.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Duygu Seçim Kartı (Satır kırılmasını ve sıkışmayı engelleyen kompakt tasarım)
  Widget _buildSentimentChoiceTile({
    required String label,
    required IconData icon,
    required Color activeColor,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: isDark ? 0.25 : 0.15)
              : (isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? activeColor : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? activeColor : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 5),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  color: isSelected
                      ? (isDark ? Colors.white : activeColor)
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Deneyimi Silme Onay Penceresi
  void _confirmDeleteReview(BuildContext context, ProductReview review, AppStrings strings) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(strings.deleteConfirmTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(strings.deleteReviewConfirmMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(strings.giveUp),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.alertRed),
            onPressed: () async {
              await _reviewRepo.deleteReview(review.id);
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              if (mounted) _loadReviews();
            },
            child: Text(strings.delete),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteProduct(BuildContext context, Product product, AppStrings strings) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(strings.deleteProductConfirmTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(strings.deleteProductConfirmMsg(strings.translateProductName(product.name))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(strings.giveUp),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.alertRed),
            onPressed: () {
              context.read<ProductCubit>().deleteProduct(product.id);
              Navigator.pop(dialogCtx);
              Navigator.pop(context);
            },
            child: Text(strings.delete),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';
import 'add_edit_product_screen.dart';
import 'product_detail_screen.dart';

/// [ProductListScreen] sınıfı, kullanıcının kayıtlı tüm kozmetik ürünlerini
/// lüks bir vitrin düzeninde, arama ve filtreleme yetenekleriyle sunduğu ana ekrandır.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);

    return Scaffold(
      // Özel Lüks Başlık Çubuğu
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.rose, AppColors.plum],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.rose.withValues(alpha: 0.35),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.spa, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(
              strings.appTitle,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: isDark ? AppColors.textPrimaryDark : AppColors.plumDark,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return AppLoadingView(message: strings.loading);
          }

          if (state is ProductError) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<ProductCubit>().loadProducts(),
            );
          }

          if (state is ProductLoaded) {
            final allProducts = state.products;

            if (allProducts.isEmpty) {
              return AppEmptyView(
                title: strings.emptyCollectionTitle,
                message: strings.emptyCollectionMessage,
                actionLabel: strings.firstProduct,
                onAction: () => _navigateToAddProduct(context),
              );
            }

            final filteredProducts = allProducts.where((p) {
              final query = _searchQuery.toLowerCase();
              final localizedName = strings.translateProductName(p.name).toLowerCase();
              return p.name.toLowerCase().contains(query) ||
                  localizedName.contains(query) ||
                  p.brand.toLowerCase().contains(query);
            }).toList();

            return CustomScrollView(
              slivers: [
                // 1. Lüks Özet ve Bilgilendirme Hero Bannerı
                SliverToBoxAdapter(
                  child: _buildHeroBanner(context, allProducts.length, isDark, strings),
                ),

                // 2. Arama ve Filtre Çubuğu
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: strings.searchHint,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark ? AppColors.rose : AppColors.plum,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 20,
                                  color: isDark ? AppColors.roseLight : AppColors.plum,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                // 3. Ürün Listesi veya Arama Sonucu Yok Uyarısı
                if (filteredProducts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyView(
                      icon: Icons.search_off_rounded,
                      title: strings.productNotFoundTitle,
                      message: strings.productNotFoundMsg(_searchQuery),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 96),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = filteredProducts[index];
                          return _buildLuxuryProductCard(context, product, isDark, strings);
                        },
                        childCount: filteredProducts.length,
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),

      // Lüks Parıltılı Yüzen Eylem Butonu
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF9E2C68), Color(0xFF6E1846)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.rose.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          onPressed: () => _navigateToAddProduct(context),
          icon: const Icon(Icons.add_rounded, size: 22),
          label: Text(
            strings.addProduct,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 0.3),
          ),
        ),
      ),
    );
  }

  /// Lüks Hero Banner Bileşeni (Üst İstatistik Kartı)
  Widget _buildHeroBanner(BuildContext context, int totalProducts, bool isDark, AppStrings strings) {
    final profileState = context.watch<ProfileCubit>().state;
    final allergenCount = profileState is ProfileLoaded
        ? profileState.profile.knownAllergens.length
        : 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isDark
            ? AppColors.heroCardGradient
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF751E4E), Color(0xFF4A1030)],
              ),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.rose.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.plum).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strings.collectionHeroTitle,
                style: const TextStyle(
                  color: AppColors.roseLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shield_outlined, size: 13, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      strings.offlineSecure,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            strings.collectionHeroSubtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatPill(
                icon: Icons.inventory_2_outlined,
                label: strings.statSavedProducts,
                value: '$totalProducts',
              ),
              const SizedBox(width: 12),
              _buildStatPill(
                icon: Icons.warning_amber_rounded,
                label: strings.statKnownAllergens,
                value: '$allergenCount',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Banner içi küçük istatistik rozeti
  Widget _buildStatPill({required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.roseLight),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.roseLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Yenilenmiş Lüks Ürün Kartı (Gradyanlı ve Yüksek Kontrastlı)
  Widget _buildLuxuryProductCard(BuildContext context, Product product, bool isDark, AppStrings strings) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        gradient: isDark ? AppColors.darkCardGradient : null,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.plum).withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(productId: product.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst Satır: Marka Rozeti ve Doğrulama Durumu
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? AppColors.roseLight : AppColors.plum,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (product.isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.safeGreen.withValues(alpha: isDark ? 0.22 : 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.safeGreen.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.safeGreen),
                            const SizedBox(width: 5),
                            Text(
                              strings.verified,
                              style: const TextStyle(
                                color: AppColors.safeGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Ürün Adı (Yüksek Kontrast, Okunabilirlik ve Dinamik Yerelleştirme)
                Text(
                  strings.translateProductName(product.name),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    letterSpacing: -0.3,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 14),

                // Alt Etiketler: İçerik sayısı, PAO, SKT (Taşma yapmadan yatay akış)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPillTag(
                        icon: Icons.science_outlined,
                        label: '${product.ingredients.length} ${strings.ingredientsCount}',
                        isDark: isDark,
                      ),
                      if (product.paoMonths != null) ...[
                        const SizedBox(width: 8),
                        _buildPillTag(
                          icon: Icons.timelapse_rounded,
                          label: '${product.paoMonths}${strings.paoTag}',
                          isDark: isDark,
                          isAlert: product.isPaoExpired,
                        ),
                      ],
                      if (product.expiryDate != null && product.isDateExpired) ...[
                        const SizedBox(width: 8),
                        _buildPillTag(
                          icon: Icons.event_busy_rounded,
                          label: strings.expiredTag,
                          isDark: isDark,
                          isAlert: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Ürün kartı içi kristal netliğinde etiket rozeti
  Widget _buildPillTag({
    required IconData icon,
    required String label,
    required bool isDark,
    bool isAlert = false,
  }) {
    final bgColor = isAlert
        ? AppColors.alertRed.withValues(alpha: isDark ? 0.25 : 0.12)
        : (isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant);

    final textColor = isAlert
        ? (isDark ? Colors.white : AppColors.alertRed)
        : (isDark ? Colors.white : AppColors.textPrimaryLight);

    final iconColor = isAlert
        ? AppColors.alertRed
        : (isDark ? AppColors.roseLight : AppColors.plum);

    final borderColor = isAlert
        ? AppColors.alertRed.withValues(alpha: 0.5)
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditProductScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/app_theme.dart';
import '../features/products/data/repositories/product_repository_impl.dart';
import '../features/products/presentation/bloc/product_cubit.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/presentation/bloc/profile_cubit.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';
import '../features/settings/domain/entities/app_settings.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';
import 'home_navigation_screen.dart';

/// [CiltiziApp] sınıfı, uygulamanın ana kök widget'ıdır.
/// BLoC/Cubit sağlayıcılarını (MultiBlocProvider) tanımlar, tema ve dil yapılandırmalarını bağlar.
class CiltiziApp extends StatelessWidget {
  const CiltiziApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Repository bağımlılıkları Clean Architecture kurallarına göre oluşturulur
    final profileRepository = ProfileRepositoryImpl();
    final productRepository = ProductRepositoryImpl();
    final settingsRepository = SettingsRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        // Ayarlar Cubit'i (Tema vb.)
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(settingsRepository)..loadSettings(),
        ),
        // Cilt Profili Cubit'i
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(profileRepository)..loadProfile(),
        ),
        // Ürünler Cubit'i
        BlocProvider<ProductCubit>(
          create: (_) => ProductCubit(productRepository)..loadProducts(),
        ),
      ],
      // Tema modu ve dil değişimi dinlenir
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return MaterialApp(
            key: ValueKey('ciltizi_${settings.languageCode}'),
            title: 'ciltİzi',
            debugShowCheckedModeBanner: false,
            locale: Locale(settings.languageCode),

            // Rose & Plum Paleti: Açık ve Koyu Temalar
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            // Kullanıcının veya sistemin belirlediği tema modu
            themeMode: settings.themeMode,

            // Başlangıç Ekranı
            home: const HomeNavigationScreen(),
          );
        },
      ),
    );
  }
}

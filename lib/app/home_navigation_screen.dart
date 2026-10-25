import 'package:flutter/material.dart';
import '../core/localization/app_strings.dart';
import '../features/products/presentation/screens/product_list_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';

/// [HomeNavigationScreen] sınıfı, uygulamanın ana gezinme çubuğunu (BottomNavigationBar)
/// ve 3 ana sekmesini (Ürünlerim, Profilim, Ayarlar) koordine eder.
class HomeNavigationScreen extends StatefulWidget {
  const HomeNavigationScreen({super.key});

  @override
  State<HomeNavigationScreen> createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  // Aktif sekme indeksi
  int _currentIndex = 0;

  // Ana sekmelerin ekran listesi
  final List<Widget> _screens = const [
    ProductListScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      // Sayfalar arası geçişte durumun korunması için IndexedStack
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // Material 3 NavigationBar bileşeni (Dinamik Dil ve Tema Desteği)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.spa_outlined),
            selectedIcon: const Icon(Icons.spa),
            label: strings.navProducts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.face_retouching_natural_outlined),
            selectedIcon: const Icon(Icons.face_retouching_natural),
            label: strings.navProfile,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: strings.navSettings,
          ),
        ],
      ),
    );
  }
}

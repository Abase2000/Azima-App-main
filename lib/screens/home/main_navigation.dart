import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'home_screen.dart';
import '../search/search_screen.dart';
import '../support/support_screen.dart';
import '../history/booking_history_screen.dart';
import '../profile/profile_screen.dart';
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}
class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final _screens = const [
    HomeScreen(),
    SearchScreen(),
    SupportScreen(),
    BookingHistoryScreen(),
    ProfileScreen(),
  ];
  final _items = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'الرئيسية'),
    BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search_rounded), label: 'البحث'),
    BottomNavigationBarItem(icon: Icon(Icons.headset_mic_outlined), activeIcon: Icon(Icons.headset_mic_rounded), label: 'الدعم'),
    BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long_rounded), label: 'حجوزاتي'),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'حسابي'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
        child: KeyedSubtree(key: ValueKey(_currentIndex), child: _screens[_currentIndex]),
      ),
    bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primary, // 👈 جعل القوائم غير المحددة ملونة وواضحة بنفس درجة الرئيسية
        unselectedIconTheme: const IconThemeData(
          color: AppColors.primary, // 👈 يضمن ظهور أيقونات القوائم الأخرى فوراً
          opacity: 1.0,
          size: 24.0,
        ),
        selectedIconTheme: const IconThemeData(
          color: AppColors.primary,
          opacity: 1.0,
          size: 26.0,
        ),
        unselectedLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        selectedLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        items: _items,
      ),
    );
  }
}

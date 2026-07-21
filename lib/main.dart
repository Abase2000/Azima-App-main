import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RehlatyMobileApp());
}
class RehlatyMobileApp extends StatelessWidget {
  const RehlatyMobileApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رحلتي',
      debugShowCheckedModeBanner: false,
      // اللغة الافتراضية
      locale: const Locale('ar'),
      // اللغات المدعومة
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      // دعم Material و Widgets و Cupertino
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // الثيم
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // اتجاه التطبيق
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      // الشاشة الأولى
      home: const SplashScreen(),
    );
  }
}
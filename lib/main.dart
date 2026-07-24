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
      // اتجاه التطبيق مع دعم التجاوب لجميع أحجام الشاشات
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 500) {
                return Container(
                  color: const Color(0xFFF3F4F6), // خلفية ناعمة للشاشات الكبيرة
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: child!,
                      ),
                    ),
                  ),
                );
              }
              return child!;
            },
          ),
        );
      },
      // الشاشة الأولى
      home: const SplashScreen(),
    );
  }
}
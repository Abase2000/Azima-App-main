import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00A896);
  static const Color primaryDark = Color(0xFF028090);
  static const Color primaryLight = Color(0xFF00695C);
  static const Color accent = Color(0xFF00332C);
  static const Color accentDark = Color(0xFF001A17);
  static const Color border = Color(0xFF9E9E9E);
  static const Color textDark = Color(0xFF1D2D44);
  static const Color textGrey = Color(0xFF748CAB);
  static const Color success = Color(0xFF2E7D32);
  static const Color danger = Color(0xFFC62828);
  static const Color warning = Color(0xFFF57F17);
}

class AppTheme {
  static const Color primaryColor = AppColors.primary; 
  static const Color primaryDark = AppColors.primaryDark;
 static const Color backgroundColor = Color(0xFFF5F6F8); // خلفية فاتحة ومريحة
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = Color(0xFF111827);   // أسود داكن وواضح جداً للنصوص الرئيسية
  static const Color textSecondary = Color(0xFF4B5563); // رمادي غامق وواضح للنصوص الفرعية
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryDark,
        surface: surfaceColor,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Cairo', fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary),
        titleLarge: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
        bodyLarge: TextStyle(fontFamily: 'Cairo', fontSize: 16, color: textPrimary),
        bodyMedium: TextStyle(fontFamily: 'Cairo', fontSize: 14, color: textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 4, 39, 36),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 230, 227, 227)),
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        labelStyle: const TextStyle(color: textSecondary, fontFamily: 'Cairo'),
        hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryDark,
        surface: Color(0xFF1E1E1E),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFF64FFDA),
        unselectedItemColor: Colors.white60,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Cairo', color: Colors.white),
        bodyMedium: TextStyle(fontFamily: 'Cairo', color: Colors.white70),
      ),
    );
  }
}

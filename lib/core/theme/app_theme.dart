import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Color Palette
  static const Color primaryBlue = Color.fromARGB(255, 30, 81, 190);
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);

  static const Color secondaryGray = Color(0xFF6B7280);
  static const Color secondaryGrayLight = Color(0xFF9CA3AF);
  static const Color secondaryGrayDark = Color(0xFF4B5563);

  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF1F2937);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF374151);

  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF4B5563);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryBlueDark,
        primaryContainer: primaryBlue,
        secondary: secondaryGray,
        secondaryContainer: secondaryGrayLight,
        surface: surfaceLight,
        background: backgroundLight,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF111827),
        onBackground: Color(0xFF111827),
        onError: Colors.white,
        outline: Color.fromARGB(255, 208, 210, 214),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 20),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // Spacing Scale
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;
}

import 'package:flutter/material.dart';

class AppTheme {
  // Core pink-red palette
  static const Color primary = Color(0xFFD72660);
  static const Color primaryDark = Color(0xFF9C1A42);
  static const Color primaryLight = Color(0xFFFF6B9D);
  static const Color accent = Color(0xFFFF2D55);
  static const Color accentWarm = Color(0xFFFF6B35);

  static const Color background = Color(0xFF1A0A10);
  static const Color surface = Color(0xFF2D1220);
  static const Color surfaceElevated = Color(0xFF3D1A2C);
  static const Color cardBg = Color(0xFFFFF5F8);
  static const Color cardShadow = Color(0xFF8B0030);

  static const Color textPrimary = Color(0xFFFFF0F5);
  static const Color textSecondary = Color(0xFFFFB3C6);
  static const Color textMuted = Color(0xFF9E6875);

  static const Color tileRed = Color(0xFFE53935);
  static const Color tileGreen = Color(0xFF2E7D32);
  static const Color tileBlue = Color(0xFF1565C0);
  static const Color tileBlack = Color(0xFF212121);
  static const Color tileGold = Color(0xFFFFD700);

  static const Color selectedGlow = Color(0xFFFF6B9D);
  static const Color matchedGlow = Color(0xFFFFD700);
  static const Color hintGlow = Color(0xFF00E5FF);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 8,
        shadowColor: cardShadow.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 8,
          shadowColor: primary.withOpacity(0.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static BoxDecoration get backgroundDecoration => BoxDecoration(
    gradient: RadialGradient(
      center: Alignment.topCenter,
      radius: 1.5,
      colors: [
        primaryDark.withOpacity(0.4),
        background,
        const Color(0xFF0D0508),
      ],
    ),
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(color: cardShadow.withOpacity(0.6), blurRadius: 8, offset: const Offset(2, 4)),
      BoxShadow(color: Colors.white.withOpacity(0.9), blurRadius: 1, offset: const Offset(-1, -1)),
    ],
    border: Border.all(color: Colors.white.withOpacity(0.6), width: 0.5),
  );

  static BoxDecoration selectedCardDecoration = BoxDecoration(
    color: const Color(0xFFFFE0ED),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(color: selectedGlow.withOpacity(0.8), blurRadius: 12, spreadRadius: 2),
      BoxShadow(color: cardShadow.withOpacity(0.4), blurRadius: 4, offset: const Offset(2, 3)),
    ],
    border: Border.all(color: selectedGlow, width: 1.5),
  );

  static BoxDecoration matchedCardDecoration = BoxDecoration(
    color: const Color(0xFFFFFDE7),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(color: matchedGlow.withOpacity(0.9), blurRadius: 16, spreadRadius: 3),
    ],
    border: Border.all(color: matchedGlow, width: 2),
  );

  static BoxDecoration hintCardDecoration = BoxDecoration(
    color: const Color(0xFFE0F7FA),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(color: hintGlow.withOpacity(0.7), blurRadius: 12, spreadRadius: 2),
    ],
    border: Border.all(color: hintGlow, width: 1.5),
  );
}
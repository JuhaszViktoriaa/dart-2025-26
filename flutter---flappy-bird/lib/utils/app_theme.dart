import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core palette: red-pink & CSS plum
  static const Color plum = Color(0xFF8B1A4A);           // deep plum
  static const Color plumLight = Color(0xFFAD2D6B);       // medium plum
  static const Color plumPale = Color(0xFFD4719E);        // soft plum/mauve
  static const Color rosePink = Color(0xFFFF4D8D);        // bright rose pink
  static const Color hotPink = Color(0xFFFF1A6C);         // hot pink / red-pink
  static const Color blushPink = Color(0xFFFFB3D1);       // blush
  static const Color cream = Color(0xFFFFF0F5);           // lavender blush white
  static const Color deepPlumBg = Color(0xFF3D0B22);      // very dark background
  static const Color midPlum = Color(0xFF5C1035);         // mid dark plum
  static const Color goldAccent = Color(0xFFFFD700);      // gold for score

  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: hotPink,
        secondary: plumLight,
        surface: deepPlumBg,
        onPrimary: cream,
        onSurface: cream,
      ),
      scaffoldBackgroundColor: deepPlumBg,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: cream,
        displayColor: cream,
      ),
      useMaterial3: true,
    );
  }
}

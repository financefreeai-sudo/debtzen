import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1B3A6B); // dark blue
  static const Color accentColor = Color(0xFF8B6914); // gold
  static const Color errorColor = Color(0xFFB03020); // red
  static const Color successColor = Color(0xFF2E7D32); // green
  static const Color warningColor = Color(0xFFF57F17); // amber
  static const Color bgColor = Color(0xFFFFFFFF); // white
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: bgColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

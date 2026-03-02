import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Locked Colour System ──────────────────────────────
  static const Color navy = Color(0xFF0A2540); // primary dark
  static const Color blue = Color(0xFF1B3A6B); // secondary
  static const Color gold = Color(0xFFC9A84C); // accent / CTA
  static const Color green = Color(0xFF00C851); // safe / positive
  static const Color amber = Color(0xFFFFB300); // caution
  static const Color red = Color(0xFFFF3B30); // danger
  static const Color bg = Color(0xFFF7F8FA); // screen background
  static const Color card = Color(0xFFFFFFFF); // card surface
  static const Color muted = Color(0xFF8A9BB0); // secondary text
  static const Color border = Color(0xFFE8ECF0); // dividers
  // ── Gradient helpers ─────────────────────────────────
  static const LinearGradient navyGradient = LinearGradient(
    colors: [navy, blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, Color(0xFFE8C96A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // ── Text Styles ───────────────────────────────────────
  static TextStyle heading(double size, {Color color = navy}) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: color,
      );
  static TextStyle label({Color color = muted}) => TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: color,
  );
  // ── Input Decoration ─────────────────────────────────
  static InputDecoration inputDecoration({String? hint, Widget? prefix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: muted, fontSize: 13),
        prefixIcon: prefix,
        filled: true,
        fillColor: bg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blue, width: 2),
        ),
      );
  // ── Elevated Button (navy) ───────────────────────────
  static Widget navyButton({
    required String label,
    required VoidCallback? onTap,
    bool loading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: loading ? muted : navy,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }

  // ── Gold Button ──────────────────────────────────────
  static Widget goldButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: goldGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gold.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
        ),
      ),
    );
  }

  // ── ThemeData ────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.light(
      primary: blue,
      secondary: gold,
      error: red,
      surface: card,
    ),
    fontFamily: 'Inter',
    textTheme: GoogleFonts.interTextTheme(),
  );
}

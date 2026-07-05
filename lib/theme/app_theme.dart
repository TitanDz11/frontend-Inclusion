import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Strict design system: Warm Minimalism / WCAG 2.2 AA
/// All color, spacing, and typography constants are defined here.
class AppTheme {
  // --- Color Palette ---
  static const Color backgroundBase = Color(0xFFFAF9F6);   // Soft cream
  static const Color surfaceCard = Color(0xFFFFFFFF);       // Pure white cards
  static const Color accentPrimary = Color(0xFF1E40AF);     // Darker vibrant blue (A11y corrected)
  static const Color alertRed = Color(0xFFB91C1C);          // Darker emergency red (A11y corrected)
  static const Color textPrimary = Color(0xFF1C1C1E);       // Dark charcoal
  static const Color textSecondary = Color(0xFF4A4A4F);     // Darker medium gray (A11y corrected)
  static const Color offlineGreen = Color(0xFF15803D);      // Darker offline indicator (A11y corrected)

  // --- Border Radius ---
  static const double radiusCard = 20.0;
  static const double radiusButton = 14.0;
  static const double radiusSmall = 10.0;

  // --- Shadows ---
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity black
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  // --- Typography ---
  static String get fontFamily => GoogleFonts.inter().fontFamily!;

  static TextStyle get headingStyle => GoogleFonts.inter(
    fontSize: 32, // Updated from 26 to match Figma
    fontWeight: FontWeight.w600, // Updated from w700
    color: textPrimary,
    height: 1.2,
  );

  static TextStyle get subheadingStyle => GoogleFonts.inter(
    fontSize: 17, // Card titles in Figma
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static TextStyle get bodyStyle => GoogleFonts.inter(
    fontSize: 14, // Common subtitle/body in Figma
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle get bodyLargeStyle => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle get captionStyle => GoogleFonts.inter(
    fontSize: 14, // Used for subtitles like "Textos con narración"
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );

  // --- Touch Targets (WCAG 2.2 AA) ---
  static const double minTouchTarget = 48.0;

  // --- Spacing ---
  static const double spacingXS = 8.0;
  static const double spacingSM = 12.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;

  /// Returns the full ThemeData for the app.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundBase,
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: const ColorScheme.light(
        primary: accentPrimary,
        error: alertRed,
        surface: surfaceCard,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundBase,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: subheadingStyle,
        iconTheme: const IconThemeData(color: textPrimary, size: 28),
      ),
      cardTheme: const CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusCard)),
        ),
        shadowColor: Color(0x0D000000),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: bodyStyle.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceCard,
        selectedItemColor: accentPrimary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CyanBlackWhite.cyan,
        brightness: Brightness.dark,
        primary: CyanBlackWhite.cyan,
        onPrimary: Colors.black,
        secondary: CyanBlackWhite.cyan,
        surface: CyanBlackWhite.darkSurface,
        onSurface: CyanBlackWhite.darkTextPrimary,
        surfaceContainerHighest: CyanBlackWhite.darkSurfaceVariant,
        background: CyanBlackWhite.darkBg,
        error: const Color(0xFFFF4D4D),
      ),
      scaffoldBackgroundColor: CyanBlackWhite.darkBg,
      textTheme: _buildTextTheme(
        CyanBlackWhite.darkTextPrimary,
        CyanBlackWhite.darkTextSecondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: CyanBlackWhite.darkBg,
        elevation: 0,
        scrolledUnderElevation: 2,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: CyanBlackWhite.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: CyanBlackWhite.white),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: CyanBlackWhite.darkSurface,
        indicatorColor: CyanBlackWhite.cyan.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: CyanBlackWhite.darkTextPrimary,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CyanBlackWhite.cyan,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      inputDecorationTheme: _buildInputTheme(
        CyanBlackWhite.darkSurface,
        CyanBlackWhite.darkDivider,
        CyanBlackWhite.darkTextPrimary,
        CyanBlackWhite.darkTextSecondary,
        CyanBlackWhite.cyan,
      ),
      dividerTheme: const DividerThemeData(color: CyanBlackWhite.darkDivider, thickness: 1),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: CyanBlackWhite.darkSurface,
        modalBackgroundColor: CyanBlackWhite.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: CyanBlackWhite.darkSurface,
        surfaceTintColor: CyanBlackWhite.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CyanBlackWhite.cyan,
        brightness: Brightness.light,
        primary: CyanBlackWhite.cyan,
        onPrimary: Colors.white,
        secondary: CyanBlackWhite.cyan,
        surface: CyanBlackWhite.lightSurface,
        onSurface: CyanBlackWhite.lightTextPrimary,
        surfaceContainerHighest: CyanBlackWhite.lightSurfaceVariant,
        background: CyanBlackWhite.lightBg,
        error: const Color(0xFFFF4D4D),
      ),
      scaffoldBackgroundColor: CyanBlackWhite.lightBg,
      textTheme: _buildTextTheme(
        CyanBlackWhite.lightTextPrimary,
        CyanBlackWhite.lightTextSecondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: CyanBlackWhite.lightBg,
        elevation: 0,
        scrolledUnderElevation: 2,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: CyanBlackWhite.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: CyanBlackWhite.black),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: CyanBlackWhite.lightSurface,
        indicatorColor: CyanBlackWhite.cyan.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CyanBlackWhite.cyan,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      inputDecorationTheme: _buildInputTheme(
        CyanBlackWhite.lightBg,
        CyanBlackWhite.lightDivider,
        CyanBlackWhite.lightTextPrimary,
        CyanBlackWhite.lightTextSecondary,
        CyanBlackWhite.cyan,
      ),
      dividerTheme: const DividerThemeData(color: CyanBlackWhite.lightDivider, thickness: 1),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: CyanBlackWhite.lightSurface,
        modalBackgroundColor: CyanBlackWhite.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: CyanBlackWhite.lightSurface,
        surfaceTintColor: CyanBlackWhite.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      cardTheme: CardThemeData(
        color: CyanBlackWhite.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: CyanBlackWhite.lightDivider, width: 1),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(fontSize: 57, fontWeight: FontWeight.w700, color: primary),
      displayMedium: GoogleFonts.plusJakartaSans(fontSize: 45, fontWeight: FontWeight.w700, color: primary),
      displaySmall: GoogleFonts.plusJakartaSans(fontSize: 36, fontWeight: FontWeight.w700, color: primary),
      headlineLarge: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w700, color: primary),
      headlineMedium: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w600, color: primary),
      headlineSmall: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w600, color: primary),
      titleLarge: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: primary),
      titleMedium: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: primary),
      titleSmall: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
      bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w400, color: primary),
      bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400, color: primary),
      bodySmall: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w400, color: secondary),
      labelLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
      labelMedium: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: secondary),
      labelSmall: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w500, color: secondary),
    );
  }

  static InputDecorationTheme _buildInputTheme(
    Color fill,
    Color border,
    Color text,
    Color hint,
    Color focus,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: border, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: border, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: focus, width: 2),
      ),
      hintStyle: GoogleFonts.plusJakartaSans(color: hint, fontSize: 14),
      labelStyle: GoogleFonts.plusJakartaSans(color: hint, fontSize: 14),
      prefixIconColor: hint,
      suffixIconColor: hint,
    );
  }
}
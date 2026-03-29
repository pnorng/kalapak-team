import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kDeepSpace,
        colorScheme: const ColorScheme.dark(
          primary: kNebulaPurple,
          secondary: kCyberBlue,
          surface: kSurface,
          onPrimary: kTextPrimary,
          onSurface: kTextPrimary,
        ),
        textTheme: _textTheme,
        appBarTheme: _appBarTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        inputDecorationTheme: _inputDecorationTheme,
        cardTheme: _cardTheme,
        chipTheme: _chipTheme,
        bottomNavigationBarTheme: _bottomNavTheme,
        dividerColor: kBorderColor,
        useMaterial3: true,
      );

  static TextTheme get _textTheme => TextTheme(
        displayLarge: GoogleFonts.firaCode(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: kTextPrimary,
        ),
        displayMedium: GoogleFonts.firaCode(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: kTextPrimary,
        ),
        displaySmall: GoogleFonts.firaCode(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: kTextPrimary,
        ),
        headlineMedium: GoogleFonts.firaCode(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: kTextPrimary,
        ),
        headlineSmall: GoogleFonts.firaCode(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: kTextPrimary,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kTextPrimary,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: kTextPrimary,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          color: kTextSecondary,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          color: kTextSecondary,
        ),
        bodySmall: GoogleFonts.nunito(
          fontSize: 12,
          color: kTextMuted,
        ),
        labelLarge: GoogleFonts.spaceMono(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: kCyberBlue,
          letterSpacing: 1.2,
        ),
      );

  static AppBarTheme get _appBarTheme => AppBarTheme(
        backgroundColor: kCosmicPurple.withOpacity(0.8),
        foregroundColor: kTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.firaCode(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kTextPrimary,
        ),
      );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: kNebulaPurple,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle:
              GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      );

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor: kSurfaceLight,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kNebulaPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        hintStyle: GoogleFonts.nunito(color: kTextMuted),
        labelStyle: GoogleFonts.nunito(color: kTextSecondary),
      );

  static CardThemeData get _cardTheme => CardThemeData(
        color: kSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kBorderColor),
        ),
      );

  static ChipThemeData get _chipTheme => ChipThemeData(
        backgroundColor: kSurfaceLight,
        labelStyle: GoogleFonts.spaceMono(fontSize: 11, color: kCyberBlue),
        side: const BorderSide(color: kBorderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      );

  static BottomNavigationBarThemeData get _bottomNavTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: kCosmicPurple,
        selectedItemColor: kNebulaPurple,
        unselectedItemColor: kTextMuted,
        selectedLabelStyle:
            GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 11),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      );
}

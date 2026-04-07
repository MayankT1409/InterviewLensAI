import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Vibrant Colors
  static const Color primaryColor = Color(0xFF7C3AED); // Modern Violet
  static const Color primaryVariant = Color(0xFF6D28D9);
  static const Color secondaryColor = Color(0xFF10B981); // Vibrant Emerald
  static const Color errorColor = Color(0xFFEF4444); // Red-500
  
  static const Color surfaceColor = Colors.white;
  static const Color backgroundColor = Color(0xFFF8FAFC); // Slate-50
  static const Color cardColor = Colors.white;
  
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onBackground = Color(0xFF0F172A); // Slate-900
  static const Color onSurface = Color(0xFF1E293B); // Slate-800
  static const Color textLight = Color(0xFF64748B); // Slate-500

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    dividerColor: const Color(0xFFE2E8F0),
    
    // Using Google Fonts (Outfit) for an incredibly modern and friendly look
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(fontSize: 57, fontWeight: FontWeight.bold, color: onSurface),
      displayMedium: GoogleFonts.outfit(fontSize: 45, fontWeight: FontWeight.bold, color: onSurface),
      displaySmall: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.bold, color: onSurface),
      headlineMedium: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w600, color: onSurface),
      headlineSmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: onSurface),
      titleLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: onSurface),
      titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface, letterSpacing: 0.15),
      titleSmall: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: onSurface, letterSpacing: 0.1),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: onSurface, letterSpacing: 0.5),
      bodyMedium: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: onSurface, letterSpacing: 0.25),
      labelLarge: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface, letterSpacing: 0.1),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: onSurface),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: GoogleFonts.outfit(
        color: onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: onPrimary,
      secondary: secondaryColor,
      onSecondary: onSecondary,
      error: errorColor,
      onError: Colors.white,
      surface: surfaceColor,
      onSurface: onSurface,
      outline: textLight,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      hintStyle: GoogleFonts.outfit(color: textLight, fontSize: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryColor, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    cardColor: const Color(0xFF1E293B),
    dividerColor: const Color(0xFF334155),
    
    // Using Google Fonts (Outfit) for an incredibly modern and friendly look
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: GoogleFonts.outfit(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
      displaySmall: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white),
      headlineSmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      titleLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
      titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.15),
      titleSmall: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white, letterSpacing: 0.1),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white, letterSpacing: 0.5),
      bodyMedium: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white, letterSpacing: 0.25),
      labelLarge: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.1),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0F172A),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF1E293B),
      onSurface: Colors.white,
      error: errorColor,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      hintStyle: GoogleFonts.outfit(color: const Color(0xFF64748B), fontSize: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryColor, width: 2.5),
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}

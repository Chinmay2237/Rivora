import 'package:flutter/material.dart';
import '../core/constants/rivora_colors.dart';

abstract class AppTheme {
  // Rivora Brand Palette Aliases
  static const Color background = RivoraColors.background;
  static const Color backgroundDeep = RivoraColors.backgroundDeep;
  static const Color surfacePrimary = RivoraColors.surface;
  static const Color surfaceSecondary = RivoraColors.surfaceElevated;
  static const Color textPrimary = RivoraColors.textPrimary;
  static const Color textSecondary = RivoraColors.textSecondary;
  static const Color textMuted = RivoraColors.textMuted;
  static const Color accentViolet = RivoraColors.primary;
  static const Color accentHighlight = RivoraColors.lavender;

  // Status & Utility Colors
  static const Color successGreen = RivoraColors.success;
  static const Color errorRed = RivoraColors.error;
  static const Color warningYellow = RivoraColors.warning;
  static const Color borderSubtle = RivoraColors.border;

  // Gradients
  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment(0, -0.6),
    radius: 1.4,
    colors: [
      Color(0xFF1B2040),
      RivoraColors.background,
    ],
  );

  static const RadialGradient stageGradient = RadialGradient(
    center: Alignment(0, 0.1),
    radius: 1.2,
    colors: [
      Color(0xFF1E2548),
      RivoraColors.backgroundDeep,
    ],
  );

  // Constants
  static const double cardRadius = 18.0;
  static const double buttonRadius = 12.0;

  static const Duration fastAnimation = Duration(milliseconds: 60);
  static const Duration normalAnimation = Duration(milliseconds: 200);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accentViolet,
        secondary: accentHighlight,
        surface: surfacePrimary,
        onSurface: textPrimary,
        error: errorRed,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfacePrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

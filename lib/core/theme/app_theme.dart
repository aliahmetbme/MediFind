// lib/core/theme/app_theme.dart
//
// Factory class that produces [ThemeData] instances for the MediFinder app.

import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_colors.dart';
import 'package:medifinder/core/theme/app_sizes.dart';
import 'package:medifinder/core/theme/app_typography.dart';

/// Factory class that produces [ThemeData] instances for the MediFinder app.
abstract final class AppTheme {
  // ── Private collaborators ─────────────────────────────────────────────────

  /// Shared typography instance for the light theme.
  static final AppTypography _lightTypography = AppTypography();

  /// Shared typography instance for the dark theme.
  static final AppTypography _darkTypography = AppTypography.dark();

  // ── Factory Method: Light Theme ───────────────────────────────────────────

  /// Returns a fully composed [ThemeData] for light mode.
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      surface: AppColors.surface,
      onPrimary: AppColors.onPrimary,
      onSurface: AppColors.textMain,
      error: AppColors.error,
      errorContainer: AppColors.errorSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _lightTypography.textTheme,
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme, _lightTypography),
      cardTheme: _buildCardTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme, _lightTypography),
    );
  }

  // ── Factory Method: Dark Theme ────────────────────────────────────────────

  /// Returns a fully composed [ThemeData] for dark mode.
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _darkTypography.textTheme,
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme, _darkTypography),
      cardTheme: _buildCardTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme, _darkTypography),
    );
  }

  // ── Private sub-theme builders (Composition helpers) ─────────────────────

  /// ElevatedButton Theme Configuration driven by theme ColorScheme and Typography.
  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme colorScheme,
    AppTypography typography,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: AppSizes.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderMedium,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.extraLarge,
          vertical: AppSizes.buttonVerticalPadding,
        ),
        textStyle: typography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Card Theme Configuration driven by theme ColorScheme and Design Tokens.
  static CardThemeData _buildCardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      color: colorScheme.surface,
      elevation: 2.0,
      shadowColor: colorScheme.onSurface.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderLarge,
      ),
    );
  }

  /// AppBar Theme Configuration driven by theme ColorScheme and Design Tokens.
  static AppBarTheme _buildAppBarTheme(
    ColorScheme colorScheme,
    AppTypography typography,
  ) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: AppSizes.zero,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: typography.titleLarge.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

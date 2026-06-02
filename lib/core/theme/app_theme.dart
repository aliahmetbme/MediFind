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
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          surface: AppColors.surface,
          onPrimary: AppColors.onPrimary,
          onSurface: AppColors.textMain,
          error: AppColors.error,
          errorContainer: AppColors.errorSurface,
        ).copyWith(
          primaryContainer: AppColors.primarySurface,
          onPrimaryContainer: AppColors.primary,
          secondary: AppColors.textSecondary,
          onSecondary: AppColors.onPrimary,
          surfaceContainerHighest: AppColors.mutedSurface,
          onSurfaceVariant: AppColors.textSecondary,
          outline: AppColors.placeholderIcon,
          outlineVariant: AppColors.border,
          shadow: AppColors.shadowMedium,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _lightTypography.textTheme,
      elevatedButtonTheme: _buildElevatedButtonTheme(_lightTypography),
      cardTheme: _buildCardTheme(),
      appBarTheme: _buildAppBarTheme(_lightTypography),
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
      primaryContainer: AppColors.primarySurface,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.textSecondary,
      onSecondary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textMain,
      surfaceContainerHighest: AppColors.mutedSurface,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.placeholderIcon,
      outlineVariant: AppColors.border,
      shadow: AppColors.shadowMedium,
      error: AppColors.error,
      errorContainer: AppColors.errorSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _darkTypography.textTheme,
      elevatedButtonTheme: _buildElevatedButtonTheme(_darkTypography),
      cardTheme: _buildCardTheme(),
      appBarTheme: _buildAppBarTheme(_darkTypography),
    );
  }

  // ── Private sub-theme builders (Composition helpers) ─────────────────────

  /// ElevatedButton Theme Configuration driven by theme ColorScheme and Typography.
  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    AppTypography typography,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSizes.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMedium),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.extraLarge,
          vertical: AppSizes.buttonVerticalPadding,
        ),
        textStyle: typography.labelLarge.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Card Theme Configuration driven by theme ColorScheme and Design Tokens.
  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: AppColors.surface,
      elevation: 2.0,
      shadowColor: AppColors.textMain.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLarge),
    );
  }

  /// AppBar Theme Configuration driven by theme ColorScheme and Design Tokens.
  static AppBarTheme _buildAppBarTheme(AppTypography typography) {
    return AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textMain,
      elevation: AppSizes.zero,
      surfaceTintColor: AppColors.transparent,
      titleTextStyle: typography.titleLarge.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

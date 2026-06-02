// lib/core/theme/app_typography.dart
//
// Typography system for the MediFinder design system. Implements the "Composition"
// pattern: AppTheme consumes AppTypography as a collaborator, pulling its
// [textTheme] property rather than inlining TextStyle definitions directly inside
// AppTheme.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medifinder/core/theme/app_colors.dart';

/// Encapsulates all [TextTheme] configuration for MediFinder.
///
/// Refined with dynamic brand color tokens to support Multi-Theme reactivity.
class AppTypography {
  final Color textColorMain;
  final Color textColorSecondary;

  AppTypography({
    this.textColorMain = AppColors.textMain,
    this.textColorSecondary = AppColors.textSecondary,
  });

  /// Factory constructor to construct typography tokens optimized for Dark Mode.
  factory AppTypography.dark() {
    return AppTypography(
      textColorMain: AppColors.onPrimary,
      textColorSecondary: AppColors.onPrimaryVariant,
    );
  }

  // ── Display / Hero ────────────────────────────────────────────────────────

  TextStyle get displayLarge => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );

  TextStyle get displayMedium => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 45,
    fontWeight: FontWeight.w700,
  );

  TextStyle get displaySmall => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );

  // ── Headlines ─────────────────────────────────────────────────────────────

  TextStyle get headlineLarge => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  TextStyle get headlineMedium => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  TextStyle get headlineSmall => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  // ── Titles ────────────────────────────────────────────────────────────────

  TextStyle get titleLarge => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  TextStyle get titleMedium => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  TextStyle get titleSmall => GoogleFonts.inter(
    color: textColorSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // ── Labels ────────────────────────────────────────────────────────────────

  TextStyle get labelLarge => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  TextStyle get labelMedium => GoogleFonts.inter(
    color: textColorSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  TextStyle get labelSmall => GoogleFonts.inter(
    color: textColorSecondary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // ── Body ──────────────────────────────────────────────────────────────────

  TextStyle get bodyLarge => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );

  TextStyle get bodyMedium => GoogleFonts.inter(
    color: textColorMain,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  TextStyle get bodySmall => GoogleFonts.inter(
    color: textColorSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // ── Custom Tokens for Pixel‑Perfect UI ────────────────────────────────────

  // Provider name (title‑like) – 15 px, bold
  static const TextStyle providerName = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textMain,
  );

  // Medium label – 13 px
  static const TextStyle labelMediumCustom = TextStyle(
    fontSize: 13.0,
    color: AppColors.textSecondary,
  );

  // Small body – 11 px
  static const TextStyle bodySmallCustom = TextStyle(
    fontSize: 11.0,
    color: AppColors.textSecondary,
  );

  // ── Composed TextTheme ────────────────────────────────────────────────────

  /// Returns a complete [TextTheme] assembled from the individual style
  /// getters above, starting from [GoogleFonts.interTextTheme] as the base
  /// so that any roles not explicitly overridden still use the Inter typeface.
  TextTheme get textTheme => GoogleFonts.interTextTheme().copyWith(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );
}

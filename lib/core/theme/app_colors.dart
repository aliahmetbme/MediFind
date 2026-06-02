// lib/core/theme/app_colors.dart
//
// Color palette for the MediFinder corporate identity.
// This class is a pure data holder (value object) consumed by AppTheme via Composition.
// It is intentionally non-instantiable – all members are static constants.
//
// ── Design rule ───────────────────────────────────────────────────────────────
// NO dependency on package:flutter/material.dart Colors.* constants.
// Every color is expressed as a self-contained hex literal so this file
// compiles with zero framework color references.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Defines the complete color palette for the MediFinder design system.
///
/// Usage (Composition): AppTheme reads these constants directly when building
/// its [ThemeData] instances. Feature layers should reference these tokens
/// instead of hard-coding hex values.
///
/// To extend the palette, add new static [Color] constants here.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────
  /// Primary action / brand blue. Hex: #2563EB
  static const Color primary = Color(0xFF2563EB);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  /// Scaffold / page background. Hex: #FAFAFA
  static const Color background = Color(0xFFFAFAFA);

  /// Card / sheet / dialog surface. Hex: #FFFFFF
  static const Color surface = Color(0xFFFFFFFF);

  // ── Text ─────────────────────────────────────────────────────────────────
  /// Primary body & heading text. Hex: #1A1A1A
  static const Color textMain = Color(0xFF1A1A1A);

  /// Captions, hints, secondary labels. Hex: #666666
  static const Color textSecondary = Color(0xFF666666);

  // ── Borders / Neutral Surfaces ──────────────────────────────────────────────
  /// Standard hairline border used around cards, inputs and dividers.
  static const Color border = Color(0xFFE5E7EB);

  /// Muted chip / placeholder background.
  static const Color mutedSurface = Color(0xFFF3F4F6);

  /// Low-emphasis icon used inside neutral placeholders.
  static const Color placeholderIcon = Color(0xFF9CA3AF);

  /// Disabled or very low-emphasis neutral icon.
  static const Color iconMuted = Color(0xFFD1D5DB);

  // ── Feedback ────────────────────────────────────────────────────────────────
  /// Error icon / action red.
  static const Color error = Color(0xFFEF4444);

  /// Pale error background.
  static const Color errorSurface = Color(0xFFFEE2E2);

  /// Rating star amber.
  static const Color rating = Color(0xFFF59E0B);

  // ── Shadows ─────────────────────────────────────────────────────────────────
  static const Color shadowSubtle = Color(0x0A000000);
  static const Color shadowSubtleDark = Color(0x0A1A1A1A);
  static const Color shadowSoft = Color(0x08000000);
  static const Color shadowMedium = Color(0x1A000000);

  // ── Semantic onColor tokens ──────────────────────────────────────────────────
  /// Full-white foreground used on [primary]-colored surfaces.
  /// Expressed as a hex literal — NO dependency on Colors.white.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// 70%-opacity white foreground used on dark surfaces (e.g. dark AppTypography).
  /// 0xB3 = round(255 × 0.70) = 178 → 0xB2 rounded to 0xB3.
  static const Color onPrimaryVariant = Color(0xB3FFFFFF);
}

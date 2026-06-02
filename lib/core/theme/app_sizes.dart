// lib/core/theme/app_sizes.dart
//
// Centralized size, padding, margin, radius, border-width, and duration tokens
// for the MediFinder design system. Strictly consumed by components and theme
// definitions to maintain a pixel-perfect, highly maintainable visual hierarchy.

import 'package:flutter/material.dart';

abstract final class AppSizes {
  // ── Spacing & Margins ────────────────────────────────────────────────────
  static const double zero = 0.0;
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 24.0;
  static const double huge = 32.0;

  // ── Spacing Helpers (EdgeInsets) ─────────────────────────────────────────
  static const EdgeInsets paddingSmall = EdgeInsets.all(small);
  static const EdgeInsets paddingMedium = EdgeInsets.all(medium);
  static const EdgeInsets paddingLarge = EdgeInsets.all(large);
  static const EdgeInsets paddingExtraLarge = EdgeInsets.all(extraLarge);

  // ── Layout Sizing Tokens ───────────────────────────────────────────────
  static const double borderThin = 1.0;
  static const double borderMedium = 1.5;
  static const double dividerHeight = 1.0;
  
  static const double appBarIconBadgeSize = 32.0;
  static const double filterBadgeSize = 28.0;
  static const double filterBadgeInnerMinSize = 16.0;
  
  static const double detailCoverHeight = 400.0;
  static const double detailProfileCardOffset = 340.0;
  static const double avatarSize = 80.0;
  static const double ratingStarSize = 20.0;
  
  static const double spacingBetweenSearchAndList = 12.0;
  static const double spacingBadgeText = 10.0;
  static const double detailImageGradientTopStop = 0.4;
  static const double detailImageGradientBottomStop = 0.5;

  static const double cardVerticalMargin = 6.0; // = AppSizes.small - 2
  static const double cityIconSpacing = 6.0; // = AppSizes.small - 2
  static const double miniSpacing = 2.0; // = AppSizes.extraSmall / 2

  // ── Button Dimensions ────────────────────────────────────────────────────
  static const double buttonHeight = 52.0;
  /// Vertical padding inside buttons: AppSizes.large - 2  (= 14.0).
  /// Named so no call-site uses raw arithmetic on tokens.
  static const double buttonVerticalPadding = 14.0;
  static const double loadingIndicatorSize = 20.0;
  static const double loadingIndicatorStrokeWidth = 2.5;
  static const double buttonBorderWidth = 1.5;

  // ── Icon Dimensions ──────────────────────────────────────────────────────
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;

  // ── State Widget Dimensions ──────────────────────────────────────────────
  static const double stateIconContainerSize = 80.0;
  static const double stateIconSize = 36.0;

  // ── Skeleton Line Heights (mirrors AppTypography font sizes) ─────────────
  static const double skeletonLineTitle = 14.0;
  static const double skeletonLineSubtitle = 12.0;
  static const double skeletonLineCaption = 11.0;

  // ── State Widget Spacing ─────────────────────────────────────────────────
  // Named tokens replace arithmetic like AppSizes.large + 4.0 (= 20)
  // or AppSizes.extraLarge + 4.0 (= 28) at call sites.
  static const double stateWidgetSpacingTitle  = 20.0; // large(16) + 4
  static const double stateWidgetSpacingAction = 28.0; // extraLarge(24) + 4

  // ── Chip & Badge Dimensions ──────────────────────────────────────────────
  static const double chipPaddingHorizontal = 16.0; // = AppSizes.large
  static const double chipPaddingVertical   = 8.0;  // = AppSizes.small
  static const double contactBadgeSize      = 42.0; // icon badge in ContactInfoRow
  static const double contactBadgeIconSize  = 20.0;
}

abstract final class AppRadius {
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 24.0;
  static const double max = 999.0;

  // ── BorderRadius Constants ───────────────────────────────────────────────
  // Using BorderRadius.all(Radius.circular(N)) instead of
  // BorderRadius.circular(N) so these can be declared `const`.
  static const BorderRadius borderExtraSmall =
      BorderRadius.all(Radius.circular(extraSmall));
  static const BorderRadius borderSmall =
      BorderRadius.all(Radius.circular(small));
  static const BorderRadius borderMedium =
      BorderRadius.all(Radius.circular(medium));
  static const BorderRadius borderLarge =
      BorderRadius.all(Radius.circular(large));
  static const BorderRadius borderExtraLarge =
      BorderRadius.all(Radius.circular(extraLarge));
  static const BorderRadius borderMax =
      BorderRadius.all(Radius.circular(max));
}

/// Centralized animation / transition duration tokens.
///
/// Every [AnimatedSwitcher], [AnimatedContainer], [AnimatedSize], and
/// [CustomTransitionPage] in the app must reference one of these constants
/// rather than inlining a raw [Duration] literal.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration chipToggle = Duration(milliseconds: 200);
  static const Duration filterExpand = Duration(milliseconds: 250);
  static const Duration shimmer = Duration(milliseconds: 1500);
  static const Duration booking = Duration(milliseconds: 1200);
}

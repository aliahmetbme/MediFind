// lib/core/components/states/shimmer_loading_widget.dart
//
// ── Responsibility ────────────────────────────────────────────────────────────
// Renders a repeating skeleton list that mirrors the exact visual structure of
// [ProviderCard]: an 80×80 image box on the left and three text lines of
// varying widths on the right — all animated with a shimmer sweep.
//
// Used by [ProviderListView] while [ResourceState] is [ResourceLoading].
// Swap in/out with a simple switch expression — no layout shifts occur because
// the skeleton occupies the identical space as the real card.
//
// Dependencies:
//   shimmer: ^3.0.0  (must be added to pubspec.yaml / flutter pub get)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:medifinder/core/theme/app_colors.dart';
import 'package:medifinder/core/theme/app_sizes.dart';

/// A full-screen shimmer skeleton list that matches the [ProviderCard] layout.
///
/// Renders [_itemCount] skeleton rows inside a non-scrollable [ListView],
/// each wrapped in a single [Shimmer.fromColors] sweep for smooth performance.
///
/// ### Usage
/// ```dart
/// switch (state) {
///   ResourceLoading() => const ShimmerLoadingWidget(),
///   ResourceSuccess(:final data) => ProviderListContent(providers: data),
///   ...
/// }
/// ```
class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({this.itemCount = 6, super.key});

  /// Number of skeleton cards to render. Defaults to 6 to fill a typical
  /// viewport; adjust based on the device's estimated visible card count.
  final int itemCount;

  // ── Shimmer colour tokens ─────────────────────────────────────────────────

  /// Base (dark) colour of the shimmer wave.
  /// [AppColors.textSecondary] at 10% opacity gives a barely-visible grey
  /// that feels clinical and non-distracting.
  static final Color _baseColor = AppColors.textSecondary.withValues(
    alpha: 0.10,
  );

  /// Highlight (light) colour swept across the skeleton.
  /// [AppColors.surface] (pure white) creates a crisp, bright sweep.
  static const Color _highlightColor = AppColors.surface;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // A single Shimmer.fromColors wraps the entire list so all skeletons
    // animate in sync — one coherent wave across the screen.
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      // Period controls wave speed — sourced from AppDurations.shimmer (1500 ms).
      period: AppDurations.shimmer,
      child: ListView.builder(
        itemCount: itemCount,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.small),
        // physics: NeverScrollableScrollPhysics is intentionally omitted so
        // a Scaffold body (not inside another scroll view).
        itemBuilder: (context, index) => const _ShimmerItem(),
      ),
    );
  }
}

// ── _ShimmerItem ──────────────────────────────────────────────────────────────

/// A single skeleton card that structurally mirrors [ProviderCard].
///
/// Layout (identical proportions to the real card):
/// ┌──────────────────────────────────────────────────────────────┐
/// │  ┌────────┐  ████████████████████████  (name — wide)         │
/// │  │ 80×80  │  ████████████  (specialty — medium)              │
/// │  │ avatar │  ████████  (city — narrow)                       │
/// │  └────────┘                                                  │
/// └──────────────────────────────────────────────────────────────┘
///
/// All coloured [Container]s are rendered opaque white; the parent
/// [Shimmer.fromColors] replaces their paint with the animated gradient.
class _ShimmerItem extends StatelessWidget {
  const _ShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.large,
        vertical: AppSizes.small - 2,
      ),
      padding: const EdgeInsets.all(AppSizes.medium),
      decoration: const BoxDecoration(
        // Must be a solid colour (not transparent) so Shimmer can paint over it.
        color: AppColors.surface,
        borderRadius: AppRadius.borderLarge,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSubtleDark,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image skeleton (80×80, AppRadius.borderMedium) ──────────────
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.surface, // shimmer paints over this
              borderRadius: AppRadius.borderMedium,
            ),
          ),

          const SizedBox(width: AppSizes.medium),

          // ── Text skeletons ───────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.extraSmall),

                // Line 1 — Name (wide, bold → taller skeleton)
                _SkeletonLine(
                  widthFactor: 0.75,
                  height: AppSizes.skeletonLineTitle,
                ),

                const SizedBox(height: AppSizes.small),

                // Line 2 — Specialty (medium width)
                _SkeletonLine(
                  widthFactor: 0.55,
                  height: AppSizes.skeletonLineSubtitle,
                ),

                const SizedBox(height: AppSizes.small),

                // Line 3 — City (narrow, with pin icon in real card)
                _SkeletonLine(
                  widthFactor: 0.40,
                  height: AppSizes.skeletonLineCaption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── _SkeletonLine ─────────────────────────────────────────────────────────────

/// A single skeleton text line with configurable width and height.
///
/// [widthFactor] is a fraction of the parent [Expanded] width (0.0 – 1.0),
/// allowing the three lines to have progressively narrower widths just like
/// the real text content (name > specialty > city).
class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor, required this.height});

  /// Fraction of the parent width (0.0 – 1.0).
  final double widthFactor;

  /// Height of the skeleton rectangle in logical pixels.
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: AppColors.surface, // shimmer paints over this
          borderRadius: AppRadius.borderExtraSmall,
        ),
      ),
    );
  }
}

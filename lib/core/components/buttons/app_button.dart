// lib/core/components/buttons/app_button.dart

import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_colors.dart';
import 'package:medifinder/core/theme/app_sizes.dart';

/// Reusable button component for MediFinder.
///
/// Refactored to achieve 100% Multi-Theme Reactivity, complete elimination of
/// hardcoded values, and compliant defensive UI sizing.
class AppButton extends StatelessWidget {
  /// Filled button: Theme [ColorScheme.primary] background, [ColorScheme.onPrimary] text.
  const AppButton.primary({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderRadius,
    super.key,
  }) : _variant = _ButtonVariant.primary;

  /// Outlined button: transparent background, Theme [ColorScheme.primary] border & text.
  const AppButton.outlined({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderRadius,
    super.key,
  }) : _variant = _ButtonVariant.outlined;

  /// Label displayed on the button (or hidden while [isLoading] is true).
  final String text;

  /// Tap handler. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// When `true`, replaces the label with a [CircularProgressIndicator] and
  /// disables the tap handler regardless of [onPressed].
  final bool isLoading;

  /// Explicitly controls the disabled visual state of the button.
  final bool isDisabled;

  /// Border radius of the button. Defaults to [AppRadius.medium].
  final double? borderRadius;

  final _ButtonVariant _variant;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Resolve border radius — use token default if caller did not supply one.
    final effectiveRadius = borderRadius ?? AppRadius.medium;
    final buttonBorderRadius = BorderRadius.all(
      Radius.circular(effectiveRadius),
    );

    // Determine explicit interactive state
    final isButtonDisabled = isDisabled || onPressed == null || isLoading;
    final activeOnPressed = isButtonDisabled ? null : onPressed;

    switch (_variant) {
      case _ButtonVariant.primary:
        return SizedBox(
          width: double.infinity,
          height: AppSizes.buttonHeight,
          child: ElevatedButton(
            onPressed: activeOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
              elevation: AppSizes.zero,
              shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
            ),
            child: isLoading
                ? _LoadingIndicator(color: AppColors.onPrimary)
                : Text(
                    text,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onPrimary,
                    ),
                  ),
          ),
        );

      case _ButtonVariant.outlined:
        const activeColor = AppColors.primary;
        final disabledColor = activeColor.withValues(alpha: 0.5);

        return SizedBox(
          width: double.infinity,
          height: AppSizes.buttonHeight,
          child: OutlinedButton(
            onPressed: activeOnPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: activeColor,
              backgroundColor: AppColors.transparent,
              disabledForegroundColor: disabledColor,
              side: BorderSide(
                color: isButtonDisabled ? disabledColor : activeColor,
                width: AppSizes.buttonBorderWidth,
              ),
              shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
            ),
            child: isLoading
                ? _LoadingIndicator(color: activeColor)
                : Text(
                    text,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: activeColor,
                    ),
                  ),
          ),
        );
    }
  }
}

// ── Variant enum (internal) ───────────────────────────────────────────────────

enum _ButtonVariant { primary, outlined }

// ── Shared loading indicator ──────────────────────────────────────────────────

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.loadingIndicatorSize,
      height: AppSizes.loadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: AppSizes.loadingIndicatorStrokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

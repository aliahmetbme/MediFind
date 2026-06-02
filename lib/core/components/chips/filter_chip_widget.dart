// lib/core/components/chips/filter_chip_widget.dart

import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_colors.dart';
import 'package:medifinder/core/theme/app_sizes.dart';

/// A tappable filter chip used in search/filter bars.
///
/// Appearance:
///   • **Selected** – [AppColors.primary] fill, [AppColors.onPrimary] label, no border.
///   • **Unselected** – transparent fill, grey border, [AppColors.textSecondary] label.
///
/// The chip always uses a stadium (fully-rounded) border via [AppRadius.borderMax].
///
/// ### Example
/// ```dart
/// FilterChipWidget(
///   label: 'Cardiology',
///   isSelected: _selectedSpecialty == 'Cardiology',
///   onTap: () => setState(() => _selectedSpecialty = 'Cardiology'),
/// )
/// ```
class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  /// Text shown inside the chip.
  final String label;

  /// Whether this chip is currently active / selected.
  final bool isSelected;

  /// Called when the chip is tapped.
  final VoidCallback onTap;

  // ── Derived style values ──────────────────────────────────────────────────

  Color get _backgroundColor =>
      isSelected ? AppColors.primary : AppColors.transparent;

  Color get _labelColor =>
      isSelected ? AppColors.onPrimary : AppColors.textSecondary;

  BorderSide get _border => isSelected
      ? BorderSide.none
      : const BorderSide(color: AppColors.iconMuted, width: 1.5);

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.chipToggle,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.chipPaddingHorizontal,
          vertical: AppSizes.chipPaddingVertical,
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: AppRadius.borderMax, // stadium shape
          border: Border.fromBorderSide(_border),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: _labelColor,
          ),
        ),
      ),
    );
  }
}

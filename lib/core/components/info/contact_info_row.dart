// lib/core/components/info/contact_info_row.dart

import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_colors.dart';
import 'package:medifinder/core/theme/app_sizes.dart';

/// A labelled info row for the provider detail screen.
///
/// Layout:
///   ┌──────────────────────────────────────────────────────┐
///   │ [●icon●]  title (small/grey)                         │
///   │           value  (bold/black)                        │
///   └──────────────────────────────────────────────────────┘
///
/// **Null / empty guard:** if [value] is `null` or an empty string the widget
/// renders [SizedBox.shrink()] and occupies no space at all – safe to use
/// unconditionally in a Column without extra conditional logic at the call site.
///
/// ### Example
/// ```dart
/// ContactInfoRow(
///   icon: Icons.phone_outlined,
///   title: 'Phone',
///   value: provider.phone, // may be null
/// )
/// ```
class ContactInfoRow extends StatelessWidget {
  const ContactInfoRow({
    required this.icon,
    required this.title,
    this.value,
    super.key,
  });

  /// Icon drawn inside the circular badge on the left.
  final IconData icon;

  /// Small grey label shown above [value] (e.g. "Phone", "Address").
  final String title;

  /// The data string to display. The widget is invisible when this is null
  /// or empty.
  final String? value;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    // ── Null / empty guard ───────────────────────────────────────────────────
    if (value == null || value.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Icon badge ─────────────────────────────────────────────────
          _IconBadge(icon: icon),

          const SizedBox(width: AppSizes.medium),

          // ── Text block ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title (small, grey)
                Text(
                  title,
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: AppSizes.extraSmall / 2),
                // Value (bold, dark)
                Text(
                  value,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Icon badge sub-widget ─────────────────────────────────────────────────────

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.contactBadgeSize,
      height: AppSizes.contactBadgeSize,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: AppSizes.contactBadgeIconSize,
        color: AppColors.primary,
      ),
    );
  }
}

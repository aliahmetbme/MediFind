// lib/core/components/states/app_empty_widget.dart

import 'package:flutter/material.dart';
import 'package:medifinder/core/components/buttons/app_button.dart';
import 'package:medifinder/core/theme/app_colors.dart';
import 'package:medifinder/core/theme/app_sizes.dart';

/// Reusable empty-state presentation for valid zero-result outcomes.
class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({
    required this.title,
    required this.message,
    this.icon = Icons.search_off_rounded,
    this.actionText,
    this.onAction,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final actionText = this.actionText;
    final onAction = this.onAction;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.huge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.stateIconContainerSize,
              height: AppSizes.stateIconContainerSize,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSizes.stateIconSize,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.stateWidgetSpacingTitle),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textMain,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.small),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textMain.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppSizes.stateWidgetSpacingAction),
              AppButton.primary(text: actionText, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

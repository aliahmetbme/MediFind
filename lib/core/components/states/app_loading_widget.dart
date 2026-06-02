// lib/core/components/states/app_loading_widget.dart

import 'package:flutter/material.dart';
import 'package:medifinder/core/theme/app_colors.dart';

/// Reusable centered loading indicator for non-list screens.
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}

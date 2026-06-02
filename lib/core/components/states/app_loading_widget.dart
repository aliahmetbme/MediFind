// lib/core/components/states/app_loading_widget.dart

import 'package:flutter/material.dart';

/// Reusable centered loading indicator for non-list screens.
///
/// Uses [Theme.of(context).colorScheme.primary] so the spinner respects the
/// active theme (light or dark) without hard-coding a static color token.
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

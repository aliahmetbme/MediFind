import 'package:flutter/widgets.dart';

// lib/core/theme/app_shadows.dart
/// Centralized design tokens for shadow visual properties.
class AppShadows {
  // Blur radii
  static const double blurSmall = 8.0;
  static const double blurMedium = 12.0;
  static const double blurLarge = 16.0;

  // Offsets
  static const Offset offsetSmall = Offset(0, 2);
  static const Offset offsetMedium = Offset(0, 4);
  static const Offset offsetNegative = Offset(0, -4);

  // Alpha values for shadow colors
  static const double alphaLow = 0.04;   // subtle shadow
  static const double alphaMedium = 0.1; // medium strength
  static const double alphaHigh = 0.08;  // higher contrast (used in app bar)
}

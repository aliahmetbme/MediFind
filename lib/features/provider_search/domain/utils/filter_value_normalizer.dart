// lib/features/provider_search/domain/utils/filter_value_normalizer.dart
//
// ── Responsibility ────────────────────────────────────────────────────────────
// Centralized domain utility logic for normalising dynamic country and city string
// inputs, and structuring them into dynamic option value objects.
//
// Pure Dart - zero dependencies on presentation (Flutter) or serialization layers.
// ─────────────────────────────────────────────────────────────────────────────

/// Canonical representation of a location or other dynamic search option.
class FilterOption {
  const FilterOption({
    required this.value, // normalized canonical key, e.g. "germany"
    required this.label, // UI polished label, e.g. "Germany"
  });

  /// The comparison/selection key (case-insensitive normalized lowercase).
  final String value;

  /// The beautiful UI visual display label.
  final String label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterOption &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          label == other.label;

  @override
  int get hashCode => value.hashCode ^ label.hashCode;

  @override
  String toString() => 'FilterOption(value: $value, label: $label)';
}

/// Central helper containing normalization and formatting algorithms for dynamic filters.
abstract final class FilterValueNormalizer {
  /// Normalizes any raw string into a trimmed, lowercase comparison token.
  static String normalize(String value) {
    return value.trim().toLowerCase();
  }

  /// Compares uppercase rune counts to pick the most descriptive case form.
  /// E.g. "New York" is chosen over "new york" or "NEW YORK".
  static bool hasBetterCasing(String newStr, String existingStr) {
    final cleanNew = newStr.trim();
    final cleanExisting = existingStr.trim();

    final newUpper = cleanNew.runes.where((r) => r >= 65 && r <= 90).length;
    final existingUpper = cleanExisting.runes
        .where((r) => r >= 65 && r <= 90)
        .length;

    return newUpper > existingUpper;
  }

  /// Formats a raw lowercase country code or name into a beautiful UI display string.
  static String formatCountry(String country) {
    final normalized = normalize(country);
    switch (normalized) {
      case 'usa':
        return 'USA';
      case 'uk':
        return 'UK';
      case 'germany':
        return 'Germany';
      case 'france':
        return 'France';
      case 'canada':
        return 'Canada';
      case 'switzerland':
        return 'Switzerland';
      case 'turkey':
        return 'Turkey';
      default:
        if (normalized.isEmpty) return '';
        // Title Case Fallback
        return normalized
            .split(' ')
            .map((word) {
              if (word.isEmpty) return '';
              return '${word[0].toUpperCase()}${word.substring(1)}';
            })
            .join(' ');
    }
  }
}

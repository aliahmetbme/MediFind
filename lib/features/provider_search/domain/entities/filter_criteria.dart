// lib/features/provider_search/domain/entities/filter_criteria.dart
//
// ── Responsibility ────────────────────────────────────────────────────────────
// Immutable value object that carries the user's active filter selections.
//
// Lives in the *domain* layer so that [IProviderRepository] (also domain) can
// reference it without creating a dependency on the data layer.
//
// Design decisions:
//   • Plain Dart class — no Freezed needed; keeps the domain layer free of
//     code-generation dependencies.
//   • Uses [Set] (not [List]) so duplicates are impossible and `contains`
//     is O(1).
//   • Specialty is a domain-controlled compile-safe enum.
//   • Country and city are data-driven, backend/mock data-driven string filters.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:medifinder/features/provider_search/domain/enums/provider_enums.dart';

/// Immutable snapshot of the user's currently selected filter chips.
///
/// An instance where all sets are empty is semantically "no filters active".
/// Use [FilterCriteria.empty()] as the canonical starting value.
class FilterCriteria {
  const FilterCriteria({
    this.selectedCountries = const {},
    this.selectedCities = const {},
    this.selectedSpecialties = const {},
  });

  /// Canonical empty filter state — use instead of the default constructor
  /// to make intent explicit at the call site.
  const FilterCriteria.empty()
    : selectedCountries = const {},
      selectedCities = const {},
      selectedSpecialties = const {};

  final Set<String> selectedCountries;
  final Set<String> selectedCities;
  final Set<ProviderSpecialty> selectedSpecialties;

  /// `true` when no filters are selected across any category.
  bool get isEmpty =>
      selectedCountries.isEmpty &&
      selectedCities.isEmpty &&
      selectedSpecialties.isEmpty;

  /// Total number of active filter chips across all categories.
  int get totalCount =>
      selectedCountries.length +
      selectedCities.length +
      selectedSpecialties.length;

  /// Returns a new [FilterCriteria] with the specified fields replaced.
  FilterCriteria copyWith({
    Set<String>? selectedCountries,
    Set<String>? selectedCities,
    Set<ProviderSpecialty>? selectedSpecialties,
  }) {
    return FilterCriteria(
      selectedCountries: selectedCountries ?? this.selectedCountries,
      selectedCities: selectedCities ?? this.selectedCities,
      selectedSpecialties: selectedSpecialties ?? this.selectedSpecialties,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FilterCriteria) return false;
    return _setsEqual(selectedCountries, other.selectedCountries) &&
        _setsEqual(selectedCities, other.selectedCities) &&
        _setsEqual(selectedSpecialties, other.selectedSpecialties);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(selectedCountries),
    Object.hashAll(selectedCities),
    Object.hashAll(selectedSpecialties),
  );

  bool _setsEqual<E>(Set<E> a, Set<E> b) =>
      a.length == b.length && a.containsAll(b);
}

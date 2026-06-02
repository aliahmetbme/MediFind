// lib/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart

import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:medifinder/core/network/app_error_mapper.dart';
import 'package:medifinder/core/network/resource_state.dart';
import 'package:medifinder/features/provider_search/domain/enums/provider_enums.dart';
import 'package:medifinder/features/provider_search/domain/entities/filter_criteria.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';
import 'package:medifinder/features/provider_search/domain/repositories/i_provider_repository.dart';
import 'package:medifinder/features/provider_search/domain/utils/filter_value_normalizer.dart';

/// Presentation-layer ViewModel for the provider search / list screen.
class ProviderListViewModel extends ChangeNotifier {
  ProviderListViewModel({
    required this.repository,
    this.debounceDuration = const Duration(milliseconds: 350),
  });

  // ── Dependencies ──────────────────────────────────────────────────────────

  final IProviderRepository repository;

  /// Duration to wait after the last query change before fetching.
  final Duration debounceDuration;

  // ── Debounce timer ────────────────────────────────────────────────────────

  Timer? _debounceTimer;

  // ── Observable state ──────────────────────────────────────────────────────

  /// Current async state of the provider list.
  ResourceState<List<ProviderEntity>> _state =
      const ResourceInitial<List<ProviderEntity>>();

  ResourceState<List<ProviderEntity>> get state => _state;

  // ── Search & filter state ─────────────────────────────────────────────────

  String _query = '';
  String get query => _query;

  FilterCriteria _criteria = const FilterCriteria.empty();
  FilterCriteria get criteria => _criteria;

  // ── Dynamic filter options (cached from all providers) ────────────────────

  List<ProviderEntity> _allProviders = [];

  /// Unique and alphabetically sorted list of country options.
  /// Wrapped in [UnmodifiableListView] to enforce absolute state immutability.
  List<FilterOption> get availableCountryOptions {
    final uniqueCountries = <String>{};
    for (final provider in _allProviders) {
      for (final country in provider.countries) {
        final normalized = FilterValueNormalizer.normalize(country);
        if (normalized.isNotEmpty) {
          uniqueCountries.add(normalized);
        }
      }
    }
    final options = uniqueCountries.map((countryValue) {
      return FilterOption(
        value: countryValue,
        label: FilterValueNormalizer.formatCountry(countryValue),
      );
    }).toList()
      ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

    return UnmodifiableListView<FilterOption>(options);
  }

  /// Unique and alphabetically sorted list of city options.
  /// Wrapped in [UnmodifiableListView] to enforce absolute state immutability.
  List<FilterOption> cityOptionsForCountries(
    Set<String> selectedCountryValues,
  ) {
    if (selectedCountryValues.isEmpty) {
      return const [];
    }

    final normalizedSelectedCountries = selectedCountryValues
        .map(FilterValueNormalizer.normalize)
        .toSet();

    final cityMap = <String, String>{};
    for (final provider in _allProviders) {
      final matchesCountry = provider.countries.any(
        (c) => normalizedSelectedCountries.contains(
          FilterValueNormalizer.normalize(c),
        ),
      );
      if (matchesCountry) {
        final city = provider.city;
        final normalizedCity = FilterValueNormalizer.normalize(city);
        if (normalizedCity.isNotEmpty) {
          final existing = cityMap[normalizedCity];
          if (existing == null ||
              FilterValueNormalizer.hasBetterCasing(city, existing)) {
            cityMap[normalizedCity] = city.trim();
          }
        }
      }
    }

    final options = cityMap.entries.map((entry) {
      return FilterOption(value: entry.key, label: entry.value);
    }).toList()
      ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

    return UnmodifiableListView<FilterOption>(options);
  }

  /// Formats a raw data-driven country code or string into a beautiful UI label.
  String formatCountryName(String country) =>
      FilterValueNormalizer.formatCountry(country);

  // ── Public actions ────────────────────────────────────────────────────────

  /// Fetches providers from the repository using the current [_query] and [_criteria].
  Future<void> fetchProviders() async {
    _state = const ResourceLoading<List<ProviderEntity>>();
    _safeNotifyListeners();

    try {
      final providers = await repository.getProviders(
        query: _query.trim().isEmpty ? null : _query.trim(),
        criteria: _criteria.isEmpty ? null : _criteria,
      );

      if (_isDisposed) return;

      if (_allProviders.isEmpty && _query.trim().isEmpty && _criteria.isEmpty) {
        _allProviders = providers;
      } else if (_allProviders.isEmpty) {
        final all = await repository.getProviders();
        if (_isDisposed) return;
        _allProviders = all;
      }

      final immutableProviders = List<ProviderEntity>.unmodifiable(providers);

      _state = immutableProviders.isEmpty
          ? const ResourceEmpty<List<ProviderEntity>>()
          : ResourceSuccess<List<ProviderEntity>>(immutableProviders);
    } on Exception catch (e) {
      if (_isDisposed) return;
      _state = ResourceError<List<ProviderEntity>>(
        AppErrorMapper.toUserMessage(e),
      );
    } catch (e) {
      if (_isDisposed) return;
      _state = ResourceError<List<ProviderEntity>>(
        AppErrorMapper.toUserMessage(e),
      );
    }

    _safeNotifyListeners();
  }

  /// Looks up a single provider by [id] via the repository.
  Future<ProviderEntity?> getProviderById(String id) {
    return repository.getProviderById(id);
  }

  /// Updates the free-text search query with debounce logic.
  void onQueryChanged(String newQuery) {
    if (_query == newQuery) return;
    _query = newQuery;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, fetchProviders);
  }

  /// Applies a new [FilterCriteria] from the filter screen and fetches.
  Future<void> applyFilterCriteria(FilterCriteria criteria) async {
    _criteria = criteria;
    await fetchProviders();
  }

  /// Toggles a country filter and re-fetches immediately.
  Future<void> toggleCountry(String country) async {
    final next = Set<String>.from(_criteria.selectedCountries);
    final normalizedTarget = FilterValueNormalizer.normalize(country);
    final existing = next.firstWhere(
      (c) => FilterValueNormalizer.normalize(c) == normalizedTarget,
      orElse: () => '',
    );
    if (existing.isNotEmpty) {
      next.remove(existing);
    } else {
      next.add(normalizedTarget);
    }

    final allowedCities = cityOptionsForCountries(next).map((c) => c.value).toSet();
    final prunedCities = _criteria.selectedCities
        .where(
          (city) => allowedCities.contains(FilterValueNormalizer.normalize(city)),
        )
        .toSet();

    await applyFilterCriteria(
      _criteria.copyWith(selectedCountries: next, selectedCities: prunedCities),
    );
  }

  /// Toggles a city filter and re-fetches immediately.
  Future<void> toggleCity(String city) async {
    final next = Set<String>.from(_criteria.selectedCities);
    final normalizedTarget = FilterValueNormalizer.normalize(city);
    final existing = next.firstWhere(
      (c) => FilterValueNormalizer.normalize(c) == normalizedTarget,
      orElse: () => '',
    );
    if (existing.isNotEmpty) {
      next.remove(existing);
    } else {
      next.add(normalizedTarget);
    }
    await applyFilterCriteria(_criteria.copyWith(selectedCities: next));
  }

  /// Toggles a [ProviderSpecialty] filter and re-fetches immediately.
  Future<void> toggleSpecialty(ProviderSpecialty specialty) async {
    final next = Set<ProviderSpecialty>.from(_criteria.selectedSpecialties);
    if (next.contains(specialty)) {
      next.remove(specialty);
    } else {
      next.add(specialty);
    }
    await applyFilterCriteria(_criteria.copyWith(selectedSpecialties: next));
  }

  /// Cancels any pending debounced search, clears query and criteria.
  Future<void> clearAll() async {
    _debounceTimer?.cancel();
    _query = '';
    _criteria = const FilterCriteria.empty();
    await fetchProviders();
  }

  // ── Lifecycle & Memory Leak Protection ────────────────────────────────────

  bool _isDisposed = false;

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    super.dispose();
  }
}

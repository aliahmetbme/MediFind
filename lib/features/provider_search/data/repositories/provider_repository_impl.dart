// lib/features/provider_search/data/repositories/provider_repository_impl.dart
//
// ── Responsibility ────────────────────────────────────────────────────────────
// Concrete implementation of [IProviderRepository].
//
// This file sits in the `data` layer — it knows about data sources (mock,
// HTTP, local DB) but the layers above it (domain, presentation) do not.
//
// Current strategy: mock simulation via [MockProviderData.rawData].
//
// Swap plan (when back-end is ready):
//   1. Inject an HTTP client (e.g. Dio) via the constructor.
//   2. Replace [_fetchRaw()] body with a real network call.
//   3. No changes needed in IProviderRepository, ViewModel, or UI.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:medifinder/features/provider_search/data/datasources/mock_provider_data.dart';
import 'package:medifinder/features/provider_search/domain/enums/provider_enum_extensions.dart';
import 'package:medifinder/features/provider_search/data/models/provider_model.dart';
import 'package:medifinder/features/provider_search/domain/entities/filter_criteria.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';
import 'package:medifinder/features/provider_search/domain/repositories/i_provider_repository.dart';
import 'package:medifinder/features/provider_search/domain/utils/filter_value_normalizer.dart';

/// Concrete data-layer implementation of [IProviderRepository].
class ProviderRepositoryImpl implements IProviderRepository {
  /// Creates a [ProviderRepositoryImpl].
  ///
  /// [shouldSimulateError] — when `true` a random 30% chance network error is
  /// simulated. Defaults to `false` (production-safe). Set to `true` only in
  /// demo/showcase builds to exercise the error UI without real network issues.
  const ProviderRepositoryImpl({this.shouldSimulateError = false});

  /// Controls the random offline error simulation.
  ///
  /// `false` (default) → production-safe, no random failures.
  /// `true`            → demo/showcase mode — 30% chance of simulated failure.
  final bool shouldSimulateError;

  // ── Public API ────────────────────────────────────────────────────────────

  @override
  Future<List<ProviderEntity>> getProviders({
    String? query,
    FilterCriteria? criteria,
  }) async {
    if (criteria != null) {
      // 1. Backend'in beklediği JSON/Query şemasını inşa et
      final Map<String, dynamic> backendQueryPayload = {
        if (query != null && query.trim().isNotEmpty)
          'search_query': query.trim(),
        'filter_countries': criteria.selectedCountries.toList(),
        'filter_cities': criteria.selectedCities.toList(),
        'filter_specialties': criteria.selectedSpecialties
            .map((s) => s.name.toLowerCase())
            .toList(),
      };

      // 2. Yapılandırılmış biçimde terminale logla
      debugPrint(
        '🚀 [Repository] HTTP GET /api/v1/providers isteği hazırlanıyor...',
      );
      debugPrint(
        '📦 [Backend Query Parameters]:\n${const JsonEncoder.withIndent('  ').convert(backendQueryPayload)}',
      );

      // NOT: Gelecekte gerçek API entegrasyonu yapıldığında remote data source katmanına
      // direkt olarak bu 'backendQueryPayload' haritası parametre olarak geçilecektir.
      // Örn: final response = await _dio.get('/providers', queryParameters: backendQueryPayload);
    }

    final rawList = await _fetchRaw();

    // ── Deserialise ───────────────────────────────────────────────────────────
    // ProviderModel.fromJson handles missing/null keys via @Default.
    var models = rawList
        .map((json) => ProviderModel.fromJson(json))
        .toList(growable: false);

    // ── In-memory filtering (operates on typed ProviderModel) ─────────────────
    if (query != null && query.trim().isNotEmpty) {
      models = _applyQuery(models, query.trim().toLowerCase());
    }
    if (criteria != null && !criteria.isEmpty) {
      models = _applyCriteria(models, criteria);
    }

    // ── Map to domain entity ──────────────────────────────────────────────────
    return models.map(_toEntity).toList(growable: false);
  }

  @override
  Future<ProviderEntity?> getProviderById(String id) async {
    // No random error simulation for single-item lookup — this is a targeted
    // navigation action and must not fail randomly.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final rawList = MockProviderData.rawData;
    final models = rawList.map((json) => ProviderModel.fromJson(json));

    try {
      final model = models.firstWhere((p) => p.id == id);
      return _toEntity(model);
    } on StateError {
      return null;
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> _fetchRaw() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (shouldSimulateError) {
      final random = DateTime.now().millisecond;
      if (random % 10 < 3) {
        throw Exception(
          'Cannot connect to the server. Please check your network connection.',
        );
      }
    }

    return MockProviderData.rawData;
  }

  /// Filters providers whose [name], [role], [city], or specialty label
  /// contains [query].
  List<ProviderModel> _applyQuery(List<ProviderModel> providers, String query) {
    return providers
        .where((p) {
          final hasSpecialtyMatch = p.specialties.any((specialty) {
            return specialty.displayName.toLowerCase().contains(query) ||
                specialty.jsonValue.toLowerCase().contains(query);
          });

          return p.name.toLowerCase().contains(query) ||
              p.role.toLowerCase().contains(query) ||
              p.city.toLowerCase().contains(query) ||
              hasSpecialtyMatch;
        })
        .toList(growable: false);
  }

  String _normalizeString(String val) => FilterValueNormalizer.normalize(val);

  /// Applies typed [FilterCriteria] to the provider list.
  ///
  /// AND logic across categories: a provider must satisfy every active
  /// category. Within a category, any matching value suffices (OR).
  List<ProviderModel> _applyCriteria(
    List<ProviderModel> providers,
    FilterCriteria criteria,
  ) {
    return providers
        .where((p) {
          if (criteria.selectedCountries.isNotEmpty) {
            final normalizedSelectedCountries = criteria.selectedCountries
                .map(_normalizeString)
                .toSet();
            final hasMatch = p.countries.any(
              (c) => normalizedSelectedCountries.contains(_normalizeString(c)),
            );
            if (!hasMatch) {
              return false;
            }
          }
          if (criteria.selectedCities.isNotEmpty) {
            final normalizedSelectedCities = criteria.selectedCities
                .map(_normalizeString)
                .toSet();
            if (!normalizedSelectedCities.contains(_normalizeString(p.city))) {
              return false;
            }
          }
          if (criteria.selectedSpecialties.isNotEmpty) {
            if (!p.specialties.any(criteria.selectedSpecialties.contains)) {
              return false;
            }
          }
          return true;
        })
        .toList(growable: false);
  }

  /// Maps a data-layer [ProviderModel] to a domain [ProviderEntity].
  ///
  /// Flattens contact info into primitive strings so the domain layer
  /// has no dependency on [ContactInfo] or [PhoneNumber] data types.
  ProviderEntity _toEntity(ProviderModel model) {
    final phone = model.contactInfo?.phone;
    return ProviderEntity(
      id: model.id,
      title: model.title,
      name: model.name,
      role: model.role,
      city: model.city,
      hospital: model.hospital,
      imageUrl: model.imageUrl,
      isBoardCertified: model.isBoardCertified,
      rating: model.rating,
      reviewCount: model.reviewCount,
      email: model.contactInfo?.email,
      phone: phone != null ? '${phone.countryCode} ${phone.number}' : null,
      about: model.about,
      specialties: model.specialties,
      availableDays: model.availableDays,
      countries: model.countries,
    );
  }
}

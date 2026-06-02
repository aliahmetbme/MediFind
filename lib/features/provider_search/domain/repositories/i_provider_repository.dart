// lib/features/provider_search/domain/repositories/i_provider_repository.dart
//
// ── Responsibility ────────────────────────────────────────────────────────────
// Defines the *contract* (abstract interface) for all provider data operations.
//
// This file lives in the `domain` layer — it imports only domain types.
// It has NO dependency on the data layer (no ProviderModel, no ContactInfo,
// no Freezed/json_serializable types).
//
// Design rationale:
//   • Abstract class over interface keyword → allows default method bodies in
//     the future without breaking implementors.
//   • Dependency Inversion: ViewModels depend on THIS abstract type, not on
//     concrete implementations.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:medifinder/features/provider_search/domain/entities/filter_criteria.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';

/// Contract that every provider data source must fulfil.
///
/// Consumers (ViewModels, use-cases) should be injected with this type, not
/// with concrete implementations, to stay decoupled from infrastructure.
abstract class IProviderRepository {
  /// Returns a list of [ProviderEntity] objects, optionally filtered by
  /// a free-text [query] and/or typed [criteria].
  ///
  /// Parameters:
  ///   [query]    – Optional free-text search term (name, specialty, city).
  ///   [criteria] – Optional typed filter criteria (country, city, specialty).
  ///
  /// Returns an empty list when no providers match — never `null`.
  /// Throws on real infrastructure failures (network, serialization, etc.).
  Future<List<ProviderEntity>> getProviders({
    String? query,
    FilterCriteria? criteria,
  });

  /// Looks up a single provider by its unique [id].
  ///
  /// Returns `null` (not an exception) when no provider matches — this
  /// allows callers to show a "not found" UI instead of crashing.
  ///
  /// Throws only on real infrastructure failures (e.g. network error).
  Future<ProviderEntity?> getProviderById(String id);
}

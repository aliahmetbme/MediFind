// lib/features/provider_search/domain/entities/provider_entity.dart
//
// ── Responsibility ────────────────────────────────────────────────────────────
// Pure domain model for a healthcare provider.
//
// Design decisions:
//   • Plain Dart class — no Freezed, no json_serializable. The domain layer
//     must not depend on code-generation or serialization infrastructure.
//   • Contact info (email, phone) is flattened into primitive String fields.
//     The data layer formats the phone string (e.g. "+1 212-555-0100") before
//     mapping — no nested objects in the domain.
//   • Specialty enum types (ProviderSpecialty) are shared between the
//     data and domain layers because they are value objects with no persistence
//     or serialization logic of their own.
//
// Separation of concerns:
//   ┌──────────────────────────────────────────────┐
//   │  data layer                                  │
//   │  ProviderModel (Freezed + json_serializable) │
//   │      ↓ mapped by ProviderRepositoryImpl      │
//   │  ProviderEntity  ←── domain layer (this file)│
//   └──────────────────────────────────────────────┘
// ─────────────────────────────────────────────────────────────────────────────

import 'package:medifinder/features/provider_search/domain/enums/provider_enums.dart';

/// Immutable domain entity representing a single healthcare provider.
///
/// All fields are plain Dart types. Nullable fields reflect that not every
/// provider exposes complete contact / rating information.
class ProviderEntity {
  const ProviderEntity({
    required this.id,
    required this.title,
    required this.name,
    required this.role,
    required this.city,
    this.hospital,
    this.imageUrl,
    this.isBoardCertified = false,
    this.rating,
    this.reviewCount,
    this.email,
    this.phone,
    this.about,
    this.specialties = const [],
    this.availableDays = const [],
    this.countries = const [],
  });

  // ── Identity ───────────────────────────────────────────────────────────────

  /// Unique identifier used for navigation and repository lookups.
  final String id;

  // ── Name / Role ────────────────────────────────────────────────────────────

  /// Honorific prefix, e.g. "Dr.", "Prof.".
  final String title;

  /// Full name, e.g. "Julian Thorne".
  final String name;

  /// Current professional role, e.g. "Senior Interventional Cardiologist".
  final String role;

  // ── Location ───────────────────────────────────────────────────────────────

  /// City where the provider primarily practices.
  final String city;

  /// Hospital or clinic name. Null when not hospital-affiliated.
  final String? hospital;

  /// Remote URL for the provider's profile photo.
  final String? imageUrl;

  /// Whether the provider holds board certification.
  final bool isBoardCertified;

  // ── Ratings ────────────────────────────────────────────────────────────────

  /// Aggregate star rating (0.0–5.0). Null when no reviews exist.
  final double? rating;

  /// Total number of patient reviews.
  final int? reviewCount;

  // ── Contact (flattened) ────────────────────────────────────────────────────

  /// Provider e-mail address. Null when not disclosed.
  final String? email;

  /// Pre-formatted phone string, e.g. "+1 212-555-0100". Null when not disclosed.
  final String? phone;

  // ── Bio ────────────────────────────────────────────────────────────────────

  /// Free-text biography. Null when not provided.
  final String? about;

  // ── Specialties & Availability ─────────────────────────────────────────────

  /// Medical specialties covered by this provider.
  final List<ProviderSpecialty> specialties;

  /// Days of the week the provider is available, e.g. ["Monday", "Friday"].
  final List<String> availableDays;

  /// Countries the provider is licensed to practice in.
  final List<String> countries;

  // ── Value equality ─────────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProviderEntity) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProviderEntity(id: $id, name: $name)';
}

// lib/features/provider_search/data/models/provider_model.dart
//
// Main domain model for a healthcare provider.
// Uses freezed for immutability / copyWith / equality and
// json_serializable for JSON (de)serialization.
//
// Code generation artifacts produced after running build_runner:
//   provider_model.freezed.dart  – boilerplate from freezed
//   provider_model.g.dart        – fromJson / toJson from json_serializable

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medifinder/features/provider_search/data/models/contact_info.dart';
import 'package:medifinder/features/provider_search/domain/enums/provider_enums.dart';

part 'provider_model.freezed.dart';
part 'provider_model.g.dart';

/// Custom specialty serializers that abstract JSON mapping inside the data layer.
List<ProviderSpecialty> _specialtiesFromJson(List<dynamic> jsonList) {
  return jsonList.map((e) {
    return switch (e.toString()) {
      'cardiology' => ProviderSpecialty.cardiology,
      'dermatology' => ProviderSpecialty.dermatology,
      'neurology' => ProviderSpecialty.neurology,
      'pediatrics' => ProviderSpecialty.pediatrics,
      'oncology' => ProviderSpecialty.oncology,
      'psychiatry' => ProviderSpecialty.psychiatry,
      'orthopedics' => ProviderSpecialty.orthopedics,
      'general_physician' => ProviderSpecialty.generalPhysician,
      _ => throw ArgumentError('Unknown specialty key: $e'),
    };
  }).toList();
}

List<String> _specialtiesToJson(List<ProviderSpecialty> specialties) {
  return specialties.map((s) {
    return switch (s) {
      ProviderSpecialty.cardiology => 'cardiology',
      ProviderSpecialty.dermatology => 'dermatology',
      ProviderSpecialty.neurology => 'neurology',
      ProviderSpecialty.pediatrics => 'pediatrics',
      ProviderSpecialty.oncology => 'oncology',
      ProviderSpecialty.psychiatry => 'psychiatry',
      ProviderSpecialty.orthopedics => 'orthopedics',
      ProviderSpecialty.generalPhysician => 'general_physician',
    };
  }).toList();
}

/// Immutable domain model representing a single healthcare provider.
///
/// Nullable fields reflect the reality that third-party APIs rarely guarantee
/// complete data. Always guard these with null checks before rendering UI.
///
/// ### Defaults
/// | Field            | Default |
/// |------------------|---------|
/// | isBoardCertified | false   |
/// | countries        | []      |
/// | specialties      | []      |
/// | availableDays    | []      |
///
/// ### JSON example
/// ```json
/// {
///   "id": "prov-001",
///   "title": "Dr.",
///   "name": "Julian Thorne",
///   "role": "Senior Interventional Cardiologist",
///   "city": "New York",
///   "isBoardCertified": true,
///   "rating": 4.8,
///   "reviewCount": 312,
///   "specialties": ["cardiology"],
///   "countries": ["usa"],
///   "availableDays": ["Monday", "Wednesday", "Friday"],
///   "contactInfo": { "email": "dr.thorne@stmarys.com" }
/// }
/// ```
@freezed
class ProviderModel with _$ProviderModel {
  const factory ProviderModel({
    // ── Identity ─────────────────────────────────────────────────────────────

    /// Unique identifier used for navigation and API lookups.
    required String id,

    /// Remote URL for the provider's profile photo. Null → show placeholder.
    String? imageUrl,

    /// Whether the provider holds board certification.
    /// Defaults to `false` when the API omits this field.
    @Default(false) bool isBoardCertified,

    // ── Name / Role ───────────────────────────────────────────────────────────

    /// Honorific prefix, e.g. "Dr.", "Prof.", "Assoc. Prof.".
    required String title,

    /// Full name of the provider, e.g. "Julian Thorne".
    required String name,

    /// Current professional role, e.g. "Senior Interventional Cardiologist".
    required String role,

    // ── Location ──────────────────────────────────────────────────────────────

    /// City where the provider primarily practices.
    required String city,

    /// Hospital or clinic name. Null when the provider is not hospital-affiliated.
    String? hospital,

    /// Countries the provider is licensed to practice in.
    /// Defaults to an empty list when the API omits this field.
    @Default(<String>[]) List<String> countries,

    // ── Ratings ───────────────────────────────────────────────────────────────

    /// Aggregate star rating (0.0 – 5.0). Null when no reviews exist yet.
    double? rating,

    /// Total number of patient reviews. Null when no reviews exist yet.
    int? reviewCount,

    // ── Contact ───────────────────────────────────────────────────────────────

    /// Structured contact details (email, phone). Null when not disclosed.
    ContactInfo? contactInfo,

    // ── Bio ───────────────────────────────────────────────────────────────────

    /// Free-text biography / about section. Null when the API omits this field.
    String? about,

    // ── Specialties & Availability ────────────────────────────────────────────

    /// Medical specialties the provider covers.
    /// Defaults to an empty list when the API omits this field.
    @Default(<ProviderSpecialty>[])
    @JsonKey(fromJson: _specialtiesFromJson, toJson: _specialtiesToJson)
    List<ProviderSpecialty> specialties,

    /// Days of the week the provider is available, e.g. ["Monday", "Friday"].
    /// Defaults to an empty list when the API omits this field.
    @Default(<String>[]) List<String> availableDays,
  }) = _ProviderModel;

  /// Deserializes a [ProviderModel] from a JSON map returned by the API.
  factory ProviderModel.fromJson(Map<String, dynamic> json) =>
      _$ProviderModelFromJson(json);
}

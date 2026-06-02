// lib/features/provider_search/data/models/contact_info.dart
//
// Freezed + json_serializable sub-models used inside ProviderModel.
//
// Code generation artifacts produced after running build_runner:
//   contact_info.freezed.dart  – immutability, copyWith, ==, toString
//   contact_info.g.dart        – fromJson / toJson

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info.freezed.dart';
part 'contact_info.g.dart';

// ── PhoneNumber ───────────────────────────────────────────────────────────────

/// A structured phone number split into country code and local number.
///
/// Both fields are required; the API is expected to provide them together or
/// omit the entire phone object (the parent [ContactInfo.phone] is nullable).
///
/// ### JSON example
/// ```json
/// { "countryCode": "+1", "number": "555-0100" }
/// ```
@freezed
class PhoneNumber with _$PhoneNumber {
  const factory PhoneNumber({
    /// ITU-T country dialling code, e.g. "+1", "+44".
    required String countryCode,

    /// Local subscriber number, e.g. "555-0100".
    required String number,
  }) = _PhoneNumber;

  /// Deserializes a [PhoneNumber] from a JSON map.
  factory PhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberFromJson(json);
}

// ── ContactInfo ───────────────────────────────────────────────────────────────

/// Contact details attached to a provider.
///
/// Both fields are optional because a provider may expose only some channels.
/// Consumers should guard with `contactInfo?.email` and `contactInfo?.phone`.
///
/// ### JSON example
/// ```json
/// {
///   "email": "dr.thorne@stmarys.com",
///   "phone": { "countryCode": "+1", "number": "555-0100" }
/// }
/// ```
@freezed
class ContactInfo with _$ContactInfo {
  const factory ContactInfo({
    /// Optional e-mail address of the provider or their practice.
    String? email,

    /// Optional structured phone number. Null when the API omits the field.
    PhoneNumber? phone,
  }) = _ContactInfo;

  /// Deserializes a [ContactInfo] from a JSON map.
  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
}

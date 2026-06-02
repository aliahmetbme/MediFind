// lib/features/provider_search/domain/enums/provider_enum_extensions.dart
//
// ── Responsibility ────────────────────────────────────────────────────────────
// Centralises enum ↔ string mapping so no two places in the codebase can
// independently derive a different string representation.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:medifinder/features/provider_search/domain/enums/provider_enums.dart';

// ── ProviderSpecialty ─────────────────────────────────────────────────────────

extension ProviderSpecialtyExtension on ProviderSpecialty {
  /// Returns the `@JsonValue` serialisation key for this specialty.
  ///
  /// Always use this instead of `.name` when comparing against filter tokens
  /// or JSON keys — the Dart identifier name and the JSON key differ for
  /// `generalPhysician` → `general_physician`.
  String get jsonValue {
    return switch (this) {
      ProviderSpecialty.cardiology => 'cardiology',
      ProviderSpecialty.dermatology => 'dermatology',
      ProviderSpecialty.neurology => 'neurology',
      ProviderSpecialty.pediatrics => 'pediatrics',
      ProviderSpecialty.oncology => 'oncology',
      ProviderSpecialty.psychiatry => 'psychiatry',
      ProviderSpecialty.orthopedics => 'orthopedics',
      ProviderSpecialty.generalPhysician => 'general_physician',
    };
  }

  /// Returns the human-readable UI label for this specialty.
  ///
  /// Use this everywhere a specialty name is displayed to the user.
  /// Centralises label mapping — no more duplicate switch expressions.
  String get displayName {
    return switch (this) {
      ProviderSpecialty.cardiology => 'Cardiology',
      ProviderSpecialty.dermatology => 'Dermatology',
      ProviderSpecialty.neurology => 'Neurology',
      ProviderSpecialty.pediatrics => 'Pediatrics',
      ProviderSpecialty.oncology => 'Oncology',
      ProviderSpecialty.psychiatry => 'Psychiatry',
      ProviderSpecialty.orthopedics => 'Orthopedics',
      ProviderSpecialty.generalPhysician => 'General Physician',
    };
  }
}

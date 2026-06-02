// test/features/provider_search/data/repositories/provider_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:medifinder/features/provider_search/domain/enums/provider_enums.dart';
import 'package:medifinder/features/provider_search/data/repositories/provider_repository_impl.dart';
import 'package:medifinder/features/provider_search/domain/entities/filter_criteria.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';

void main() {
  // Deterministic repository — shouldSimulateError: false prevents the 30%
  // random offline failure from causing non-deterministic test results.
  late ProviderRepositoryImpl repository;

  setUp(() {
    repository = const ProviderRepositoryImpl(shouldSimulateError: false);
  });

  // ── getProviders — query ───────────────────────────────────────────────────

  group('getProviders — query filtering', () {
    test('returns all providers when no query/criteria provided', () async {
      final providers = await repository.getProviders();
      expect(providers, isNotEmpty);
      expect(providers.first, isA<ProviderEntity>());
    });

    test(
      'all mock providers expose a non-empty bio for detail screens',
      () async {
        final providers = await repository.getProviders();

        expect(providers, isNotEmpty);
        expect(
          providers.every((p) => p.about != null && p.about!.trim().isNotEmpty),
          isTrue,
        );
      },
    );

    test('filters by name (case-insensitive)', () async {
      final providers = await repository.getProviders(query: 'priya');
      expect(providers.length, greaterThanOrEqualTo(1));
      expect(
        providers.every(
          (p) =>
              p.name.toLowerCase().contains('priya') ||
              p.role.toLowerCase().contains('priya') ||
              p.city.toLowerCase().contains('priya'),
        ),
        isTrue,
      );
    });

    test('filters by specialty display name', () async {
      final providers = await repository.getProviders(query: 'cardiology');

      expect(providers, isNotEmpty);
      expect(
        providers.every(
          (p) => p.specialties.contains(ProviderSpecialty.cardiology),
        ),
        isTrue,
      );
    });

    test('returns empty list for query that matches nothing', () async {
      final providers = await repository.getProviders(
        query: 'zzz_no_match_xyz',
      );
      expect(providers, isEmpty);
    });
  });

  // ── getProviders — country filter ──────────────────────────────────────────

  group('getProviders — country filter', () {
    test('filters by single country (germany)', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(selectedCountries: {'germany'}),
      );
      expect(providers, isNotEmpty);
      for (final p in providers) {
        expect(p.countries, contains('germany'));
      }
    });

    test(
      'filters by single country (france) — returns Lyon + Paris providers',
      () async {
        final providers = await repository.getProviders(
          criteria: const FilterCriteria(selectedCountries: {'france'}),
        );
        expect(providers.length, greaterThanOrEqualTo(2));
        for (final p in providers) {
          expect(p.countries, contains('france'));
        }
      },
    );

    test('multiple countries returns union of results', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(selectedCountries: {'usa', 'uk'}),
      );
      expect(providers, isNotEmpty);
      for (final p in providers) {
        final hasMatch =
            p.countries.contains('usa') || p.countries.contains('uk');
        expect(hasMatch, isTrue);
      }
    });

    test('filters by non-enum country code like turkey', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(selectedCountries: {'turkey'}),
      );
      expect(providers, isNotEmpty);
      expect(providers.any((p) => p.id == 'prov-014'), isTrue);
      for (final p in providers) {
        expect(p.countries, contains('turkey'));
      }
    });

    test('case-insensitivity and trim works on selected countries', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(selectedCountries: {' GERMANY '}),
      );
      expect(providers, isNotEmpty);
      for (final p in providers) {
        expect(p.countries, contains('germany'));
      }
    });
  });

  // ── getProviders — city filter ─────────────────────────────────────────────

  group('getProviders — city filter', () {
    test('city filter (New York) returns only New York providers', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(selectedCities: {'New York'}),
      );
      expect(providers, isNotEmpty);
      for (final p in providers) {
        expect(p.city.toLowerCase(), contains('new york'));
      }
    });

    test('city filter for a city with no mock data returns empty', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(selectedCities: {'Seattle'}),
      );
      expect(providers, isEmpty);
    });

    test('city filter (Istanbul) works for non-enum values', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(selectedCities: {'Istanbul'}),
      );
      expect(providers, isNotEmpty);
      expect(providers.length, 1);
      expect(providers.first.id, 'prov-014');
      expect(providers.first.city, 'Istanbul');
    });

    test('case-insensitivity and trim works on selected cities', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(selectedCities: {' istanbul '}),
      );
      expect(providers, isNotEmpty);
      expect(providers.length, 1);
      expect(providers.first.id, 'prov-014');
    });
  });

  // ── getProviders — specialty filter ───────────────────────────────────────

  group('getProviders — specialty filter', () {
    test('cardiology filter returns only cardiologists', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(
          selectedSpecialties: {ProviderSpecialty.cardiology},
        ),
      );
      expect(providers, isNotEmpty);
      for (final p in providers) {
        expect(p.specialties, contains(ProviderSpecialty.cardiology));
      }
    });

    test(
      'General Physician filter returns prov-008 (enum != JSON key regression)',
      () async {
        final providers = await repository.getProviders(
          criteria: const FilterCriteria(
            selectedSpecialties: {ProviderSpecialty.generalPhysician},
          ),
        );
        expect(
          providers,
          isNotEmpty,
          reason: 'General Physician filter must return results',
        );
        expect(
          providers.any((p) => p.id == 'prov-008'),
          isTrue,
          reason:
              'prov-008 (Thomas Berg) must be included in General Physician results',
        );
      },
    );

    test(
      'multiple specialty filter returns providers matching any specialty',
      () async {
        final providers = await repository.getProviders(
          criteria: const FilterCriteria(
            selectedSpecialties: {
              ProviderSpecialty.cardiology,
              ProviderSpecialty.neurology,
            },
          ),
        );
        expect(providers.length, greaterThanOrEqualTo(2));
        for (final p in providers) {
          final hasMatch =
              p.specialties.contains(ProviderSpecialty.cardiology) ||
              p.specialties.contains(ProviderSpecialty.neurology);
          expect(hasMatch, isTrue);
        }
      },
    );
  });

  // ── getProviders — combined criteria (AND logic) ───────────────────────────

  group('getProviders — combined criteria (AND)', () {
    test('country AND specialty together narrow results correctly', () async {
      final providers = await repository.getProviders(
        criteria: const FilterCriteria(
          selectedCountries: {'germany'},
          selectedSpecialties: {ProviderSpecialty.neurology},
        ),
      );
      // Both Prof. Steiner (prov-003) and Prof. Hans Mueller (prov-013) match: germany + neurology.
      expect(providers.length, 2);
      final ids = providers.map((p) => p.id).toList();
      expect(ids, containsAll(['prov-003', 'prov-013']));
    });
  });

  // ── getProviderById ────────────────────────────────────────────────────────

  group('getProviderById', () {
    test('returns the correct provider for a known id', () async {
      final provider = await repository.getProviderById('prov-001');
      expect(provider, isNotNull);
      expect(provider?.id, 'prov-001');
      expect(provider?.name, 'Julian Thorne');
    });

    test('returns null (not an exception) for an unknown id', () async {
      final provider = await repository.getProviderById('unknown-id');
      expect(provider, isNull);
    });

    test('returns null for an empty id string', () async {
      final provider = await repository.getProviderById('');
      expect(provider, isNull);
    });
  });
}

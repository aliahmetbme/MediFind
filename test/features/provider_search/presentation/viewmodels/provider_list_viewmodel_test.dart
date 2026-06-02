// test/features/provider_search/presentation/viewmodels/provider_list_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:medifinder/core/network/resource_state.dart';
import 'package:medifinder/features/provider_search/domain/enums/provider_enums.dart';
import 'package:medifinder/features/provider_search/domain/entities/filter_criteria.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';
import 'package:medifinder/features/provider_search/domain/repositories/i_provider_repository.dart';
import 'package:medifinder/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart';

// ── Fake Repository for Testing ─────────────────────────────────────────────

class FakeProviderRepository implements IProviderRepository {
  bool shouldFail = false;
  List<ProviderEntity> fakeData;
  ProviderEntity? fakeProviderById;

  FakeProviderRepository({List<ProviderEntity>? data})
    : fakeData =
          data ??
          [
            const ProviderEntity(
              id: 'prov-001',
              name: 'Test Doctor',
              title: 'Dr.',
              role: 'Cardiologist',
              city: 'New York',
              specialties: [ProviderSpecialty.cardiology],
              countries: ['usa'],
            ),
          ];

  @override
  Future<List<ProviderEntity>> getProviders({
    String? query,
    FilterCriteria? criteria,
  }) async {
    if (shouldFail) {
      throw Exception('Fake network error');
    }
    return fakeData;
  }

  @override
  Future<ProviderEntity?> getProviderById(String id) async {
    if (shouldFail) {
      throw Exception('Fake network error');
    }
    return fakeProviderById;
  }
}

// ── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late ProviderListViewModel viewModel;
  late FakeProviderRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeProviderRepository();
    // Use a zero debounce duration for testing so we don't have to fakeAsync
    viewModel = ProviderListViewModel(
      repository: fakeRepository,
      debounceDuration: Duration.zero,
    );
  });

  group('Initial state', () {
    test('initial state is ResourceInitial', () {
      expect(viewModel.state, isA<ResourceInitial<List<ProviderEntity>>>());
    });

    test('initial criteria is empty', () {
      expect(viewModel.criteria.isEmpty, isTrue);
    });
  });

  group('fetchProviders — success', () {
    test(
      'transitions Loading → ResourceSuccess when data is non-empty',
      () async {
        final fetchFuture = viewModel.fetchProviders();
        expect(viewModel.state, isA<ResourceLoading<List<ProviderEntity>>>());

        await fetchFuture;

        expect(viewModel.state, isA<ResourceSuccess<List<ProviderEntity>>>());
        final state = viewModel.state as ResourceSuccess<List<ProviderEntity>>;
        expect(state.data.length, 1);
        expect(state.data.first.name, 'Test Doctor');
      },
    );
  });

  group(
    'fetchProviders — empty result → ResourceEmpty (not ResourceError)',
    () {
      test('empty list from repository sets state to ResourceEmpty', () async {
        fakeRepository.fakeData = []; // simulate no-match search result
        await viewModel.fetchProviders();

        // Must be ResourceEmpty — NOT ResourceError
        expect(
          viewModel.state,
          isA<ResourceEmpty<List<ProviderEntity>>>(),
          reason:
              'An empty result must produce ResourceEmpty, not ResourceError',
        );
      });

      test('ResourceEmpty is NOT triggered when data is non-empty', () async {
        await viewModel.fetchProviders();
        expect(
          viewModel.state,
          isNot(isA<ResourceEmpty<List<ProviderEntity>>>()),
        );
      });
    },
  );

  group('fetchProviders — exception → ResourceError (not ResourceEmpty)', () {
    test('exception from repository sets state to ResourceError', () async {
      fakeRepository.shouldFail = true;
      await viewModel.fetchProviders();

      expect(
        viewModel.state,
        isA<ResourceError<List<ProviderEntity>>>(),
        reason:
            'A real exception must produce ResourceError, not ResourceEmpty',
      );
      // Error message must be user-friendly (not a raw stack trace dump)
      final state = viewModel.state as ResourceError<List<ProviderEntity>>;
      expect(state.message, isNotEmpty);
      expect(state.message.toLowerCase(), isNot(contains('exception')));
    });
  });

  group('typed filter toggles', () {
    test('toggleSpecialty adds and removes specialty from criteria', () async {
      expect(viewModel.criteria.selectedSpecialties, isEmpty);

      await viewModel.toggleSpecialty(ProviderSpecialty.cardiology);
      expect(
        viewModel.criteria.selectedSpecialties,
        contains(ProviderSpecialty.cardiology),
      );

      await viewModel.toggleSpecialty(ProviderSpecialty.cardiology);
      expect(viewModel.criteria.selectedSpecialties, isEmpty);
    });

    test('toggleCountry adds and removes country from criteria', () async {
      await viewModel.toggleCountry('usa');
      expect(viewModel.criteria.selectedCountries, contains('usa'));

      await viewModel.toggleCountry('usa');
      expect(viewModel.criteria.selectedCountries, isEmpty);
    });

    test('toggleCity adds and removes city from criteria', () async {
      await viewModel.toggleCity('New York');
      expect(viewModel.criteria.selectedCities, contains('new york'));

      await viewModel.toggleCity('New York');
      expect(viewModel.criteria.selectedCities, isEmpty);
    });

    test('multiple categories can be selected simultaneously', () async {
      await viewModel.toggleCountry('usa');
      await viewModel.toggleCity('New York');
      await viewModel.toggleSpecialty(ProviderSpecialty.cardiology);

      expect(viewModel.criteria.selectedCountries, contains('usa'));
      expect(viewModel.criteria.selectedCities, contains('new york'));
      expect(
        viewModel.criteria.selectedSpecialties,
        contains(ProviderSpecialty.cardiology),
      );
      expect(viewModel.criteria.totalCount, 3);
    });
  });

  group('clearAll', () {
    test('clearAll resets all criteria and query', () async {
      await viewModel.toggleSpecialty(ProviderSpecialty.cardiology);
      await viewModel.toggleCountry('usa');
      viewModel.onQueryChanged('test');
      await Future.delayed(Duration.zero); // let debounce tick

      expect(viewModel.criteria.isEmpty, isFalse);
      expect(viewModel.query, 'test');

      await viewModel.clearAll();

      expect(viewModel.criteria.isEmpty, isTrue);
      expect(viewModel.query, '');
    });

    test(
      'clearAll re-fetches and returns to ResourceSuccess on non-empty data',
      () async {
        await viewModel.toggleSpecialty(ProviderSpecialty.cardiology);
        await viewModel.clearAll();
        expect(viewModel.state, isA<ResourceSuccess<List<ProviderEntity>>>());
      },
    );
  });

  group('getProviderById', () {
    test('returns provider when fakeProviderById is set', () async {
      fakeRepository.fakeProviderById = const ProviderEntity(
        id: 'prov-001',
        title: 'Dr.',
        name: 'Julian Thorne',
        role: 'Cardiologist',
        city: 'New York',
      );

      final result = await viewModel.getProviderById('prov-001');
      expect(result, isNotNull);
      expect(result?.id, 'prov-001');
    });

    test('returns null when provider is not found (no exception)', () async {
      fakeRepository.fakeProviderById = null;

      final result = await viewModel.getProviderById('unknown-id');
      expect(result, isNull);
    });
  });

  group('dynamic location options and progressive disclosure', () {
    test(
      'cityOptionsForCountries returns empty list when country selection is empty',
      () async {
        await viewModel.fetchProviders();
        final cities = viewModel.cityOptionsForCountries({});
        expect(cities, isEmpty);
      },
    );

    test(
      'cityOptionsForCountries returns correct cities under selected countries',
      () async {
        fakeRepository.fakeData = [
          const ProviderEntity(
            id: 'prov-001',
            title: 'Dr.',
            name: 'Doctor A',
            role: 'Doctor',
            city: 'Berlin',
            countries: ['germany'],
          ),
          const ProviderEntity(
            id: 'prov-002',
            title: 'Dr.',
            name: 'Doctor B',
            role: 'Doctor',
            city: 'Munich',
            countries: ['germany'],
          ),
          const ProviderEntity(
            id: 'prov-003',
            title: 'Dr.',
            name: 'Doctor C',
            role: 'Doctor',
            city: 'New York',
            countries: ['usa'],
          ),
        ];
        await viewModel.fetchProviders();

        final germanyCities = viewModel.cityOptionsForCountries({'germany'});
        expect(
          germanyCities.map((c) => c.label),
          containsAll(['Berlin', 'Munich']),
        );
        expect(germanyCities.map((c) => c.label), isNot(contains('New York')));

        final combinedCities = viewModel.cityOptionsForCountries({
          'germany',
          'usa',
        });
        expect(
          combinedCities.map((c) => c.label),
          containsAll(['Berlin', 'Munich', 'New York']),
        );
      },
    );

    test(
      'toggleCountry automatically prunes invalid selected cities from criteria',
      () async {
        fakeRepository.fakeData = [
          const ProviderEntity(
            id: 'prov-001',
            title: 'Dr.',
            name: 'Doctor A',
            role: 'Doctor',
            city: 'Berlin',
            countries: ['germany'],
          ),
          const ProviderEntity(
            id: 'prov-002',
            title: 'Dr.',
            name: 'Doctor B',
            role: 'Doctor',
            city: 'New York',
            countries: ['usa'],
          ),
        ];
        await viewModel.fetchProviders();

        // Start with both usa and germany active, and New York selected
        await viewModel.toggleCountry('usa');
        await viewModel.toggleCountry('germany');
        await viewModel.toggleCity('New York');

        expect(
          viewModel.criteria.selectedCountries,
          containsAll(['usa', 'germany']),
        );
        expect(viewModel.criteria.selectedCities, contains('new york'));

        // Toggling off 'usa' should automatically remove 'new york' city from criteria since Berlin is the only available city for Germany
        await viewModel.toggleCountry('usa');

        expect(viewModel.criteria.selectedCountries, contains('germany'));
        expect(viewModel.criteria.selectedCountries, isNot(contains('usa')));
        expect(viewModel.criteria.selectedCities, isNot(contains('new york')));
        expect(viewModel.criteria.selectedCities, isEmpty);
      },
    );
  });

  group('debounce behavior', () {
    test('onQueryChanged debounces fetch calls', () async {
      final localViewModel = ProviderListViewModel(
        repository: fakeRepository,
        debounceDuration: const Duration(milliseconds: 50),
      );

      localViewModel.onQueryChanged('a');
      localViewModel.onQueryChanged('ab');
      localViewModel.onQueryChanged('abc');

      expect(localViewModel.query, 'abc');
      // State hasn't changed yet because of debounce
      expect(
        localViewModel.state,
        isA<ResourceInitial<List<ProviderEntity>>>(),
      );

      // Wait for debounce
      await Future.delayed(const Duration(milliseconds: 60));

      // Now it should have fetched
      expect(
        localViewModel.state,
        isA<ResourceSuccess<List<ProviderEntity>>>(),
      );
    });
  });
}

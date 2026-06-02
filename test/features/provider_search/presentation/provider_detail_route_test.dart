// test/features/provider_search/presentation/provider_detail_route_test.dart
//
// Widget / integration tests for ProviderDetailView routing safety.
//
// These tests guard against the crash risks identified in Faz 1.A:
//   • state.extra as ProviderEntity (hard cast) → _CastError
//   • No state.pathParameters['id'] lookup fallback
//   • canPop() == false → no back navigation
//
// Test strategy: pump ProviderDetailView directly (not via full router) so
// we can control the exact constructor arguments without network overhead.
// The FakeProviderRepository is reused from the ViewModel tests.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:medifinder/core/network/resource_state.dart';

import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';
import 'package:medifinder/features/provider_search/domain/entities/filter_criteria.dart';
import 'package:medifinder/features/provider_search/domain/repositories/i_provider_repository.dart';
import 'package:medifinder/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart';
import 'package:medifinder/features/provider_search/presentation/views/provider_detail_view.dart';

// ── Fake repository ────────────────────────────────────────────────────────

class _FakeRepo implements IProviderRepository {
  final ProviderEntity? providerById;
  _FakeRepo({this.providerById});

  @override
  Future<List<ProviderEntity>> getProviders({
    String? query,
    FilterCriteria? criteria,
  }) async => [];

  @override
  Future<ProviderEntity?> getProviderById(String id) async => providerById;
}

// ── Helper ────────────────────────────────────────────────────────────────────

Widget _wrapWithProvider(Widget child, IProviderRepository repo) {
  return ChangeNotifierProvider(
    create: (_) => ProviderListViewModel(repository: repo),
    child: MaterialApp(home: child),
  );
}

const _kSampleProvider = ProviderEntity(
  id: 'prov-001',
  title: 'Dr.',
  name: 'Julian Thorne',
  role: 'Cardiologist',
  city: 'New York',
);

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('ProviderDetailView — routing safety', () {
    testWidgets(
      'renders successfully with cachedProvider (no repository fetch needed)',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithProvider(
            const ProviderDetailView(
              providerId: 'prov-001',
              cachedProvider: _kSampleProvider,
            ),
            _FakeRepo(),
          ),
        );
        // No loading state — cachedProvider is used immediately.
        await tester.pump();

        // Provider name appears in the profile card.
        expect(find.textContaining('Julian Thorne'), findsWidgets);
        expect(find.text('Book Appointment'), findsOneWidget);
      },
    );

    testWidgets('renders successfully without cachedProvider (fetches by id)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithProvider(
          const ProviderDetailView(
            providerId: 'prov-001',
            // cachedProvider intentionally omitted — simulates deep link
          ),
          _FakeRepo(providerById: _kSampleProvider),
        ),
      );

      // Allow all async work (initState → _loadProvider → setState) to settle.
      await tester.pumpAndSettle();

      // Provider must be displayed without crash.
      expect(find.textContaining('Julian Thorne'), findsWidgets);
      expect(find.text('Book Appointment'), findsOneWidget);
    });

    testWidgets('shows not-found UI for unknown id — no crash', (tester) async {
      await tester.pumpWidget(
        _wrapWithProvider(
          const ProviderDetailView(providerId: 'unknown-id'),
          _FakeRepo(providerById: null), // repo returns null → not found
        ),
      );

      await tester.pumpAndSettle();

      // Must show a not-found message, not crash.
      expect(find.text('Provider Not Found'), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
    });

    testWidgets('shows not-found UI for blank/empty id — no crash', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithProvider(
          const ProviderDetailView(
            providerId: '', // blank id from bad deep link
          ),
          _FakeRepo(),
        ),
      );

      await tester.pump(); // allow initState to run
      await tester.pump(); // allow setState

      expect(find.text('Provider Not Found'), findsOneWidget);
    });

    testWidgets(
      'wrong-type extra (e.g. String) does not crash — uses repository fallback',
      (tester) async {
        // This simulates the router receiving wrong-type extra gracefully.
        // The router now safe-casts (is ProviderEntity check), so cachedProvider
        // arrives as null here — the view falls back to the repository.
        await tester.pumpWidget(
          _wrapWithProvider(
            const ProviderDetailView(
              providerId: 'prov-001',
              cachedProvider: null, // wrong-type extra → safe-cast → null
            ),
            _FakeRepo(providerById: _kSampleProvider),
          ),
        );

        await tester.pumpAndSettle();

        // No crash — provider loaded via repository.
        expect(find.textContaining('Julian Thorne'), findsWidgets);
      },
    );
  });

  group('ResourceState — Empty vs Error distinction', () {
    test('ResourceEmpty is a distinct type from ResourceError', () {
      const empty = ResourceEmpty<List<ProviderEntity>>();
      const error = ResourceError<List<ProviderEntity>>('oops');

      expect(empty, isA<ResourceEmpty<List<ProviderEntity>>>());
      expect(empty, isNot(isA<ResourceError<List<ProviderEntity>>>()));
      expect(error, isNot(isA<ResourceEmpty<List<ProviderEntity>>>()));
    });
  });
}

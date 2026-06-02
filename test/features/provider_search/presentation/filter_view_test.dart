import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medifinder/features/provider_search/domain/entities/filter_criteria.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';
import 'package:medifinder/features/provider_search/domain/repositories/i_provider_repository.dart';
import 'package:medifinder/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart';
import 'package:medifinder/features/provider_search/presentation/views/filter_view.dart';
import 'package:provider/provider.dart';

class _CountingRepository implements IProviderRepository {
  int getProvidersCallCount = 0;

  @override
  Future<List<ProviderEntity>> getProviders({
    String? query,
    FilterCriteria? criteria,
  }) async {
    getProvidersCallCount += 1;
    return const <ProviderEntity>[
      ProviderEntity(
        id: 'prov-001',
        title: 'Dr.',
        name: 'Julian Thorne',
        role: 'Cardiologist',
        city: 'Berlin',
        countries: ['germany'],
      ),
    ];
  }

  @override
  Future<ProviderEntity?> getProviderById(String id) async => null;
}

Future<void> _pumpFilterRoute(
  WidgetTester tester,
  ProviderListViewModel viewModel,
) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: Text('Home')),
      ),
      GoRoute(
        path: '/filters',
        builder: (context, state) => const FilterView(),
      ),
    ],
  );

  await tester.pumpWidget(
    ChangeNotifierProvider<ProviderListViewModel>.value(
      value: viewModel,
      child: MaterialApp.router(routerConfig: router),
    ),
  );

  router.push('/filters');
  await tester.pumpAndSettle();
}

void main() {
  group('FilterView draft/apply behavior', () {
    testWidgets('starts draft state from the current ViewModel criteria', (
      tester,
    ) async {
      final repository = _CountingRepository();
      final viewModel = ProviderListViewModel(repository: repository);
      await viewModel.fetchProviders(); // Cache baseline dynamic options
      repository.getProvidersCallCount =
          0; // Reset count for the test assertions

      await viewModel.applyFilterCriteria(
        const FilterCriteria(selectedCountries: {'germany'}),
      );
      repository.getProvidersCallCount = 0;

      await _pumpFilterRoute(tester, viewModel);

      expect(find.text('1 selected'), findsOneWidget);
      expect(viewModel.criteria.selectedCountries, contains('germany'));
      expect(repository.getProvidersCallCount, 0);
    });

    testWidgets('chip toggle only updates draft before apply', (tester) async {
      final repository = _CountingRepository();
      final viewModel = ProviderListViewModel(repository: repository);
      await viewModel.fetchProviders(); // Cache options
      repository.getProvidersCallCount = 0; // Reset baseline fetch count

      await _pumpFilterRoute(tester, viewModel);

      // 'germany' country formats to 'Germany' in availableCountries display mapper
      await tester.tap(find.text('Germany'));
      await tester.pumpAndSettle();

      expect(find.text('1 selected'), findsOneWidget);
      expect(viewModel.criteria.isEmpty, isTrue);
      expect(repository.getProvidersCallCount, 0);
    });

    testWidgets('apply commits draft criteria and fetches once', (
      tester,
    ) async {
      final repository = _CountingRepository();
      final viewModel = ProviderListViewModel(repository: repository);
      await viewModel.fetchProviders(); // Cache options
      repository.getProvidersCallCount = 0; // Reset baseline fetch count

      await _pumpFilterRoute(tester, viewModel);

      await tester.tap(find.text('Germany'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Selection'));
      await tester.pumpAndSettle();

      expect(viewModel.criteria.selectedCountries, contains('germany'));
      expect(repository.getProvidersCallCount, 1); // 1 apply call
    });

    testWidgets('close discards draft changes', (tester) async {
      final repository = _CountingRepository();
      final viewModel = ProviderListViewModel(repository: repository);
      await viewModel.fetchProviders(); // Cache options
      repository.getProvidersCallCount = 0; // Reset baseline fetch count

      await _pumpFilterRoute(tester, viewModel);

      await tester.tap(find.text('Germany'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Close filters'));
      await tester.pumpAndSettle();

      expect(viewModel.criteria.isEmpty, isTrue);
      expect(repository.getProvidersCallCount, 0); // No new calls
    });

    testWidgets('reset clears draft, but close keeps original criteria', (
      tester,
    ) async {
      final repository = _CountingRepository();
      final viewModel = ProviderListViewModel(repository: repository);
      await viewModel.fetchProviders(); // Cache options
      repository.getProvidersCallCount = 0; // Reset baseline fetch count

      await viewModel.applyFilterCriteria(
        const FilterCriteria(selectedCountries: {'germany'}),
      );
      repository.getProvidersCallCount = 0;

      await _pumpFilterRoute(tester, viewModel);

      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Close filters'));
      await tester.pumpAndSettle();

      expect(viewModel.criteria.selectedCountries, contains('germany'));
      expect(repository.getProvidersCallCount, 0);
    });

    testWidgets('reset plus apply commits empty criteria', (tester) async {
      final repository = _CountingRepository();
      final viewModel = ProviderListViewModel(repository: repository);
      await viewModel.fetchProviders(); // Cache options
      repository.getProvidersCallCount = 0; // Reset baseline fetch count

      await viewModel.applyFilterCriteria(
        const FilterCriteria(selectedCountries: {'germany'}),
      );
      repository.getProvidersCallCount = 0;

      await _pumpFilterRoute(tester, viewModel);

      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Selection'));
      await tester.pumpAndSettle();

      expect(viewModel.criteria.isEmpty, isTrue);
      expect(repository.getProvidersCallCount, 1); // 1 apply call
    });
  });

  group('FilterView progressive locations visibility', () {
    testWidgets(
      'City chips and header are NOT rendered when no country is selected',
      (tester) async {
        final repository = _CountingRepository();
        final viewModel = ProviderListViewModel(repository: repository);
        await viewModel.fetchProviders();

        await _pumpFilterRoute(tester, viewModel);

        // Verify Country chip 'Germany' is present
        expect(find.text('Germany'), findsOneWidget);

        // Verify City section header/chips are NOT present initially
        expect(find.text('City'), findsNothing);
        expect(find.text('Berlin'), findsNothing);
      },
    );

    testWidgets(
      'Selecting a Country renders the City section with its respective cities and supports cascading pruning',
      (tester) async {
        final repository = _CountingRepository();
        final viewModel = ProviderListViewModel(repository: repository);
        await viewModel.fetchProviders();

        await _pumpFilterRoute(tester, viewModel);

        // 1. Initial State: No country selected -> No City section
        expect(find.text('City'), findsNothing);
        expect(find.text('Berlin'), findsNothing);

        // 2. Select 'Germany' -> City section should expand and 'Berlin' should become visible
        await tester.tap(find.text('Germany'));
        await tester.pumpAndSettle();

        expect(find.text('City'), findsOneWidget);
        expect(find.text('Berlin'), findsOneWidget);

        // 3. Select 'Berlin' -> Should update selection count
        await tester.tap(find.text('Berlin'));
        await tester.pumpAndSettle();
        expect(find.text('2 selected'), findsOneWidget); // 1 country + 1 city

        // 4. Deselect 'Germany' -> City section should collapse, and Berlin should be automatically pruned
        await tester.tap(find.text('Germany'));
        await tester.pumpAndSettle();

        expect(find.text('City'), findsNothing);
        expect(find.text('Berlin'), findsNothing);
        expect(
          find.text('No filters active'),
          findsOneWidget,
        ); // All pruned and deselected!
      },
    );
  });
}

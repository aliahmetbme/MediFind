import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medifinder/features/provider_search/domain/entities/filter_criteria.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';
import 'package:medifinder/features/provider_search/domain/repositories/i_provider_repository.dart';
import 'package:medifinder/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart';
import 'package:medifinder/features/provider_search/presentation/views/provider_list_view.dart';
import 'package:provider/provider.dart';

class _ProviderListRepository implements IProviderRepository {
  @override
  Future<List<ProviderEntity>> getProviders({
    String? query,
    FilterCriteria? criteria,
  }) async {
    return const <ProviderEntity>[];
  }

  @override
  Future<ProviderEntity?> getProviderById(String id) async => null;
}

Future<void> _pumpProviderList(
  WidgetTester tester,
  ProviderListViewModel viewModel,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<ProviderListViewModel>.value(
      value: viewModel,
      child: const MaterialApp(home: ProviderListView()),
    ),
  );
}

void main() {
  group('ProviderListView filter badge', () {
    testWidgets('hides the filter badge when no filters are active', (
      tester,
    ) async {
      final viewModel = ProviderListViewModel(
        repository: _ProviderListRepository(),
      );

      await _pumpProviderList(tester, viewModel);

      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('shows active filter count on the filter icon', (tester) async {
      final viewModel = ProviderListViewModel(
        repository: _ProviderListRepository(),
      );

      await viewModel.applyFilterCriteria(
        const FilterCriteria(
          selectedCountries: {'germany'},
          selectedCities: {'seattle'},
        ),
      );

      await _pumpProviderList(tester, viewModel);

      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });
  });
}

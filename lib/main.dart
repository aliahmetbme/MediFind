// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medifinder/core/router/app_router.dart';
import 'package:medifinder/core/theme/app_theme.dart';
import 'package:medifinder/features/provider_search/data/repositories/provider_repository_impl.dart';
import 'package:medifinder/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediFinderApp());
}

class MediFinderApp extends StatelessWidget {
  const MediFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ProviderListViewModel is scoped at the app level because the search
        // state should survive route transitions (e.g. list → detail → back).
        // Inject the concrete repository here; swap to a fake in tests.
        ChangeNotifierProvider<ProviderListViewModel>(
          create: (_) =>
              ProviderListViewModel(repository: const ProviderRepositoryImpl())
                ..fetchProviders(), // kick off the initial load immediately
        ),
      ],
      child: MaterialApp.router(
        title: 'MediFinder',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

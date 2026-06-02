// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medifinder/core/router/app_router.dart';
import 'package:medifinder/core/theme/app_theme.dart';
import 'package:medifinder/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart';
import 'package:medifinder/features/provider_search/domain/repositories/i_provider_repository.dart';
import 'package:medifinder/features/provider_search/domain/services/i_error_mapper.dart';
import 'package:medifinder/core/services/id_debounce_service.dart';
import 'package:medifinder/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize service locator and register dependencies
  setupServiceLocator();
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
        // Retrieve the repository instance from the service locator.
        ChangeNotifierProvider<ProviderListViewModel>(
          create: (_) => ProviderListViewModel(
            repository: serviceLocator<IProviderRepository>(),
            errorMapper: serviceLocator<IErrorMapper>(),
            debounceService: serviceLocator<IDebounceService>(),
          )..fetchProviders(), // kick off the initial load immediately
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

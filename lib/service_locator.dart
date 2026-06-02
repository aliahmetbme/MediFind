// lib/service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:medifinder/core/services/id_debounce_service.dart';
import 'package:medifinder/core/services/debounce_service.dart';
import 'package:medifinder/features/provider_search/domain/services/i_error_mapper.dart';
import 'package:medifinder/core/services/error_mapper_adapter.dart';
import 'package:medifinder/features/provider_search/data/repositories/provider_repository_impl.dart';
import 'package:medifinder/features/provider_search/domain/repositories/i_provider_repository.dart';

/// Global service locator instance.
final GetIt serviceLocator = GetIt.instance;

/// Registers all app-wide dependencies.
/// Call this once at app startup (e.g., in `main()` before `runApp`).
void setupServiceLocator() {
  // Register the Provider repository as a lazy singleton.
  if (!serviceLocator.isRegistered<IProviderRepository>()) {
    serviceLocator.registerLazySingleton<IProviderRepository>(
      () => ProviderRepositoryImpl(),
    );
    // Register error mapper adapter
    if (!serviceLocator.isRegistered<IErrorMapper>()) {
      serviceLocator.registerLazySingleton<IErrorMapper>(
        () => ErrorMapperAdapter(),
      );
    }
    // Register debounce service
    if (!serviceLocator.isRegistered<IDebounceService>()) {
      serviceLocator.registerLazySingleton<IDebounceService>(
        () => DebounceService(),
      );
    }
  }
}

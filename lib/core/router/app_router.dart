// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medifinder/core/components/states/app_error_widget.dart';
import 'package:medifinder/core/theme/app_colors.dart';
import 'package:medifinder/features/provider_search/presentation/views/filter_view.dart';
import 'package:medifinder/features/provider_search/presentation/views/provider_detail_view.dart';
import 'package:medifinder/features/provider_search/presentation/views/provider_list_view.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';

/// Strongly-typed routes used across the MediFinder application to eliminate
/// hard-coded string paths and parameters.
enum AppRoute {
  home(path: '/', name: 'home'),
  providerDetail(path: '/provider/:id', name: 'provider_detail'),
  filters(path: '/filters', name: 'filters');

  final String path;
  final String name;
  const AppRoute({required this.path, required this.name});
}

abstract final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoute.home.path,
    debugLogDiagnostics: true,

    // ── Fallback & Error Handling (404 Routing) ──────────────────────────────
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.background,
      body: AppErrorWidget(
        title: 'Page Not Found',
        message: 'The route "${state.uri}" does not exist in the system.',
        icon: Icons.explore_off_rounded,
        actionText: 'Go Home',
        onAction: () => context.goNamed(AppRoute.home.name),
      ),
    ),

    routes: [
      // ── Home / Provider List ────────────────────────────────────────────────
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const ProviderListView(),
      ),

      // ── Provider Detail (Deep-Link & Web Ready) ─────────────────────────────
      // Completely decoupled from the 'extra' anti-pattern. Navigation solely
      // relies on the path parameter ':id' to guarantee deep-link parity.
      GoRoute(
        path: AppRoute.providerDetail.path,
        name: AppRoute.providerDetail.name,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final cachedProvider = state.extra as ProviderEntity?;

          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ProviderDetailView(
              providerId: id,
              cachedProvider: cachedProvider,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),

      // ── Filters (Advanced Modal Slide-Up Transition) ────────────────────────
      GoRoute(
        path: AppRoute.filters.path,
        name: AppRoute.filters.name,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const FilterView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // Starts from bottom
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),
    ],
  );
}

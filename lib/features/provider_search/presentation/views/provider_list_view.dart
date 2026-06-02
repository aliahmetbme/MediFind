// lib/features/provider_search/presentation/views/provider_list_view.dart
//
// The primary list screen of the MediFinder app.
// Fully refactored to achieve 100% Multi-Theme Reactivity and strictly enforce Design Tokens.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medifinder/core/router/app_router.dart';
import 'package:medifinder/core/components/cards/provider_card.dart';
import 'package:medifinder/core/components/states/app_empty_widget.dart';
import 'package:medifinder/core/components/states/app_error_widget.dart';
import 'package:medifinder/core/components/states/shimmer_loading_widget.dart';
import 'package:medifinder/core/network/resource_state.dart';
import 'package:medifinder/core/theme/app_sizes.dart';
import 'package:medifinder/features/provider_search/domain/enums/provider_enum_extensions.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';
import 'package:medifinder/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart';

class ProviderListView extends StatelessWidget {
  const ProviderListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewModel = context.read<ProviderListViewModel>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const _MediFinderAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchBar(onChanged: viewModel.onQueryChanged),
          const SizedBox(height: AppSizes.spacingBetweenSearchAndList),
          Expanded(
            child: Consumer<ProviderListViewModel>(
              builder: (context, vm, _) {
                return _buildBody(context, vm);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProviderListViewModel viewModel) {
    final state = viewModel.state;

    return AnimatedSwitcher(
      duration: AppDurations.normal,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: switch (state) {
        ResourceInitial() => const ShimmerLoadingWidget(
            key: ValueKey('initial'),
          ),
        ResourceLoading() => const ShimmerLoadingWidget(
            key: ValueKey('loading'),
          ),
        ResourceSuccess(:final data) => _ProviderList(
            key: const ValueKey('success'),
            providers: data,
          ),
        ResourceEmpty() => AppEmptyWidget(
            key: const ValueKey('empty'),
            title: 'No Results Found',
            message: 'No providers match your search or filters. Try adjusting your criteria.',
            actionText: 'Clear Search',
            onAction: viewModel.clearAll,
          ),
        ResourceError(:final message) => AppErrorWidget(
            key: const ValueKey('error'),
            title: 'Something Went Wrong',
            message: message,
            actionText: 'Try Again',
            onAction: viewModel.fetchProviders,
          ),
      },
    );
  }
}

class _MediFinderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MediFinderAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(AppSizes.dividerHeight),
        child: Container(height: AppSizes.dividerHeight, color: colorScheme.outlineVariant),
      ),
      title: Row(
        children: [
          Container(
            width: AppSizes.appBarIconBadgeSize,
            height: AppSizes.appBarIconBadgeSize,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: AppRadius.borderSmall,
            ),
            child: Icon(
              Icons.local_hospital_rounded,
              color: colorScheme.onPrimary,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSizes.spacingBadgeText),
          Text(
            'MediFinder',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      actions: [
        Selector<ProviderListViewModel, int>(
          selector: (_, viewModel) => viewModel.criteria.totalCount,
          builder: (context, activeFilterCount, _) {
            return IconButton(
              icon: _FilterIconWithBadge(count: activeFilterCount),
              tooltip: activeFilterCount == 0
                  ? 'Advanced filters'
                  : '$activeFilterCount active filters',
              onPressed: () {
                context.pushNamed(AppRoute.filters.name);
              },
            );
          },
        ),
      ],
    );
  }
}

class _FilterIconWithBadge extends StatelessWidget {
  const _FilterIconWithBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasActiveFilters = count > 0;
    final label = count > 99 ? '99+' : count.toString();

    return SizedBox(
      width: AppSizes.filterBadgeSize,
      height: AppSizes.filterBadgeSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Icon(Icons.tune_rounded, color: colorScheme.onSurfaceVariant),
          ),
          if (hasActiveFilters)
            Positioned(
              top: -2,
              right: -2,
              child: Semantics(
                label: '$count active filters',
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: AppSizes.filterBadgeInnerMinSize,
                    minHeight: AppSizes.filterBadgeInnerMinSize,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: AppRadius.borderMax,
                    border: Border.all(color: colorScheme.surface, width: AppSizes.borderMedium),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.large, AppSizes.large, AppSizes.large, AppSizes.small),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Search by name, specialty or city…',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () {
                  _controller.clear();
                  widget.onChanged('');
                },
                child: Icon(
                  Icons.cancel_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              );
            },
          ),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.large,
            vertical: AppSizes.medium,
          ),
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderMedium,
            borderSide: BorderSide(color: colorScheme.outlineVariant, width: AppSizes.borderThin),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderMedium,
            borderSide: BorderSide(color: colorScheme.outlineVariant, width: AppSizes.borderThin),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderMedium,
            borderSide: BorderSide(color: colorScheme.primary, width: AppSizes.borderMedium),
          ),
        ),
      ),
    );
  }
}

class _ProviderList extends StatelessWidget {
  const _ProviderList({required this.providers, super.key});
  final List<ProviderEntity> providers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: AppSizes.small, bottom: AppSizes.extraLarge),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        final specialtyLabel = provider.specialties.isNotEmpty
            ? provider.specialties.first.displayName
            : provider.role;

        return ProviderCard(
          name: '${provider.title} ${provider.name}',
          specialty: specialtyLabel,
          city: provider.city,
          rating: provider.rating,
          imageUrl: provider.imageUrl,
          heroTag: provider.id,
          onTap: () {
            context.pushNamed(
              AppRoute.providerDetail.name,
              pathParameters: {'id': provider.id},
              extra: provider,
            );
          },
        );
      },
    );
  }
}

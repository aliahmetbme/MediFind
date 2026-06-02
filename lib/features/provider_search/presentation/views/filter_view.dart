// lib/features/provider_search/presentation/views/filter_view.dart
//
// Advanced filter screen for the MediFinder provider search feature.
// Fully refactored to achieve 100% Multi-Theme Reactivity and strictly enforce Design Tokens.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medifinder/core/router/app_router.dart';
import 'package:medifinder/core/components/buttons/app_button.dart';
import 'package:medifinder/core/components/chips/filter_chip_widget.dart';
import 'package:medifinder/core/theme/app_sizes.dart';
import 'package:medifinder/features/provider_search/domain/enums/provider_enums.dart';
import 'package:medifinder/features/provider_search/domain/enums/provider_enum_extensions.dart';
import 'package:medifinder/features/provider_search/domain/entities/filter_criteria.dart';
import 'package:medifinder/features/provider_search/domain/utils/filter_value_normalizer.dart';
import 'package:medifinder/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart';

const List<ProviderSpecialty> _kSpecialtyOptions = [
  ProviderSpecialty.cardiology,
  ProviderSpecialty.dermatology,
  ProviderSpecialty.neurology,
  ProviderSpecialty.pediatrics,
  ProviderSpecialty.oncology,
  ProviderSpecialty.psychiatry,
  ProviderSpecialty.orthopedics,
  ProviderSpecialty.generalPhysician,
];

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  late FilterCriteria _draft;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ProviderListViewModel>();
    _draft = viewModel.criteria;
  }

  void _toggleCountry(String country) {
    setState(() {
      final next = Set<String>.from(_draft.selectedCountries);
      final normalizedTarget = FilterValueNormalizer.normalize(country);
      final existing = next.firstWhere(
        (c) => FilterValueNormalizer.normalize(c) == normalizedTarget,
        orElse: () => '',
      );
      if (existing.isNotEmpty) {
        next.remove(existing);
      } else {
        next.add(normalizedTarget);
      }

      final viewModel = context.read<ProviderListViewModel>();
      final allowedCities = viewModel
          .cityOptionsForCountries(next)
          .map((c) => c.value)
          .toSet();
      final prunedCities = _draft.selectedCities
          .where(
            (city) =>
                allowedCities.contains(FilterValueNormalizer.normalize(city)),
          )
          .toSet();

      _draft = _draft.copyWith(
        selectedCountries: next,
        selectedCities: prunedCities,
      );
    });
  }

  void _toggleCity(String city) {
    setState(() {
      final next = Set<String>.from(_draft.selectedCities);
      final normalizedTarget = FilterValueNormalizer.normalize(city);
      final existing = next.firstWhere(
        (c) => FilterValueNormalizer.normalize(c) == normalizedTarget,
        orElse: () => '',
      );
      if (existing.isNotEmpty) {
        next.remove(existing);
      } else {
        next.add(normalizedTarget);
      }
      _draft = _draft.copyWith(selectedCities: next);
    });
  }

  void _toggleSpecialty(ProviderSpecialty specialty) {
    setState(() {
      final next = Set<ProviderSpecialty>.from(_draft.selectedSpecialties);
      if (next.contains(specialty)) {
        next.remove(specialty);
      } else {
        next.add(specialty);
      }
      _draft = _draft.copyWith(selectedSpecialties: next);
    });
  }

  void _resetDraft() {
    setState(() {
      _draft = const FilterCriteria.empty();
    });
  }

  void _applyAndPop() {
    final viewModel = context.read<ProviderListViewModel>();
    viewModel.applyFilterCriteria(_draft);
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRoute.home.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewModel = context.watch<ProviderListViewModel>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      resizeToAvoidBottomInset: false,
      appBar: _FilterAppBar(
        draftCount: _draft.totalCount,
      ),
      body: Column(
        children: [
          Expanded(
            child: _FilterScrollBody(
              draft: _draft,
              countryOptions: viewModel.availableCountryOptions,
              cityOptions: viewModel.cityOptionsForCountries(
                _draft.selectedCountries,
              ),
              onToggleCountry: _toggleCountry,
              onToggleCity: _toggleCity,
              onToggleSpecialty: _toggleSpecialty,
            ),
          ),
          _StickyActionBar(
            hasActiveFilters: !_draft.isEmpty,
            onReset: _resetDraft,
            onApply: _applyAndPop,
          ),
        ],
      ),
    );
  }
}

class _FilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _FilterAppBar({required this.draftCount});
  final int draftCount;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.close_rounded, color: colorScheme.onSurfaceVariant),
        tooltip: 'Close filters',
        onPressed: () => context.pop(),
      ),
      title: Text('Filters', style: textTheme.titleLarge),
      actions: [
        if (draftCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.large),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingBadgeText,
                  vertical: AppSizes.extraSmall,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: AppRadius.borderMax,
                ),
                child: Text(
                  '$draftCount selected',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(AppSizes.dividerHeight),
        child: Container(height: AppSizes.dividerHeight, color: colorScheme.outlineVariant),
      ),
    );
  }
}

class _FilterScrollBody extends StatelessWidget {
  const _FilterScrollBody({
    required this.draft,
    required this.countryOptions,
    required this.cityOptions,
    required this.onToggleCountry,
    required this.onToggleCity,
    required this.onToggleSpecialty,
  });

  final FilterCriteria draft;
  final List<FilterOption> countryOptions;
  final List<FilterOption> cityOptions;
  final void Function(String) onToggleCountry;
  final void Function(String) onToggleCity;
  final void Function(ProviderSpecialty) onToggleSpecialty;

  Widget _buildFilterCard(BuildContext context, {required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.large),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: colorScheme.outlineVariant, width: AppSizes.borderThin),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSizes.large, AppSizes.extraLarge, AppSizes.large, AppSizes.large),
      children: [
        Text('Find your specialist', style: textTheme.headlineSmall),
        const SizedBox(height: AppSizes.extraSmall),
        Text(
          'Tailor your search with precise medical filters.',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSizes.extraLarge),
        _buildFilterCard(
          context,
          child: _CountryFilterSection(
            options: countryOptions,
            draft: draft,
            onToggle: onToggleCountry,
          ),
        ),
        AnimatedSize(
          duration: AppDurations.filterExpand,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: draft.selectedCountries.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSizes.large),
                  child: _buildFilterCard(
                    context,
                    child: _CityFilterSection(
                      options: cityOptions,
                      draft: draft,
                      onToggle: onToggleCity,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSizes.large),
        _buildFilterCard(
          context,
          child: _SpecialtyFilterSection(
            options: _kSpecialtyOptions,
            draft: draft,
            onToggle: onToggleSpecialty,
          ),
        ),
        const SizedBox(height: AppSizes.stateWidgetSpacingTitle),
        _ResultPreviewCard(
          draftCount: draft.totalCount,
        ),
      ],
    );
  }
}

class _CountryFilterSection extends StatelessWidget {
  const _CountryFilterSection({
    required this.options,
    required this.draft,
    required this.onToggle,
  });

  final List<FilterOption> options;
  final FilterCriteria draft;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.public_rounded,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSizes.small),
            Text('Country', style: textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: AppSizes.medium),
        if (options.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.small),
            child: Text(
              'No country options available.',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          )
        else
          Wrap(
            spacing: AppSizes.small,
            runSpacing: AppSizes.small,
            children: options.map((option) {
              return FilterChipWidget(
                label: option.label,
                isSelected: draft.selectedCountries.contains(option.value),
                onTap: () => onToggle(option.value),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _CityFilterSection extends StatelessWidget {
  const _CityFilterSection({
    required this.options,
    required this.draft,
    required this.onToggle,
  });

  final List<FilterOption> options;
  final FilterCriteria draft;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_city_rounded,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSizes.small),
            Text('City', style: textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: AppSizes.medium),
        if (options.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.small),
            child: Text(
              'No city options available.',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          )
        else
          Wrap(
            spacing: AppSizes.small,
            runSpacing: AppSizes.small,
            children: options.map((option) {
              return FilterChipWidget(
                label: option.label,
                isSelected: draft.selectedCities.contains(option.value),
                onTap: () => onToggle(option.value),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _SpecialtyFilterSection extends StatelessWidget {
  const _SpecialtyFilterSection({
    required this.options,
    required this.draft,
    required this.onToggle,
  });

  final List<ProviderSpecialty> options;
  final FilterCriteria draft;
  final void Function(ProviderSpecialty) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_hospital_rounded,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSizes.small),
            Text('Specialty', style: textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: AppSizes.medium),
        Wrap(
          spacing: AppSizes.small,
          runSpacing: AppSizes.small,
          children: options.map((option) {
            return FilterChipWidget(
              label: option.displayName,
              isSelected: draft.selectedSpecialties.contains(option),
              onTap: () => onToggle(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ResultPreviewCard extends StatelessWidget {
  const _ResultPreviewCard({
    required this.draftCount,
  });
  final int draftCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.stateWidgetSpacingTitle),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.borderLarge,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.15),
          width: AppSizes.borderThin,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.contactBadgeSize,
            height: AppSizes.contactBadgeSize,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderMedium,
            ),
            child: Icon(
              Icons.people_alt_rounded,
              color: colorScheme.primary,
              size: AppSizes.iconMedium,
            ),
          ),
          const SizedBox(width: AppSizes.large),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  draftCount == 0
                      ? 'No filters active'
                      : '$draftCount filter${draftCount > 1 ? 's' : ''} selected',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.extraSmall),
                Text(
                  draftCount == 0
                      ? 'Tap the chips above to narrow results.'
                      : 'Tap "Apply Selection" to see matching specialists.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyActionBar extends StatelessWidget {
  const _StickyActionBar({
    required this.hasActiveFilters,
    required this.onReset,
    required this.onApply,
  });

  final bool hasActiveFilters;
  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.large,
        AppSizes.medium,
        AppSizes.large,
        MediaQuery.paddingOf(context).bottom + AppSizes.medium,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant, width: AppSizes.borderThin)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (hasActiveFilters) ...[
            Expanded(
              flex: 2,
              child: AppButton.outlined(
                text: 'Reset',
                borderRadius: AppRadius.large,
                onPressed: onReset,
              ),
            ),
            const SizedBox(width: AppSizes.medium),
          ],
          Expanded(
            flex: 3,
            child: AppButton.primary(
              text: 'Apply Selection',
              borderRadius: AppRadius.large,
              onPressed: onApply,
            ),
          ),
        ],
      ),
    );
  }
}

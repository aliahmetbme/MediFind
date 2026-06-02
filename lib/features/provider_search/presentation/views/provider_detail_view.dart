// lib/features/provider_search/presentation/views/provider_detail_view.dart
//
// Displays the full profile details of a single provider.
// Fully refactored to achieve 100% Multi-Theme Reactivity and strictly enforce Design Tokens.

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medifinder/core/router/app_router.dart';
import 'package:medifinder/core/network/resource_state.dart';
import 'package:medifinder/core/components/buttons/app_button.dart';
import 'package:medifinder/core/components/info/contact_info_row.dart';
import 'package:medifinder/core/components/states/app_empty_widget.dart';
import 'package:medifinder/core/components/states/app_error_widget.dart';
import 'package:medifinder/core/components/states/app_loading_widget.dart';
import 'package:medifinder/core/theme/app_shadows.dart';
import 'package:medifinder/core/theme/app_gradients.dart';
import 'package:medifinder/core/theme/app_colors.dart';
import 'package:medifinder/core/theme/app_sizes.dart';
import 'package:medifinder/features/provider_search/domain/enums/provider_enum_extensions.dart';
import 'package:medifinder/features/provider_search/domain/entities/provider_entity.dart';
import 'package:medifinder/features/provider_search/presentation/viewmodels/provider_list_viewmodel.dart';

class ProviderDetailView extends StatefulWidget {
  const ProviderDetailView({
    required this.providerId,
    this.cachedProvider,
    super.key,
  });

  final String providerId;
  final ProviderEntity? cachedProvider;

  @override
  State<ProviderDetailView> createState() => _ProviderDetailViewState();
}

class _ProviderDetailViewState extends State<ProviderDetailView> {
  ResourceState<ProviderEntity> _detailState = const ResourceInitial();

  @override
  void initState() {
    super.initState();
    if (widget.cachedProvider != null) {
      final provider = widget.cachedProvider!;
      _detailState = ResourceSuccess(provider);
    } else {
      _loadProvider();
    }
  }

  Future<void> _loadProvider() async {
    if (widget.providerId.trim().isEmpty) {
      setState(() {
        _detailState = const ResourceError('Provider not found.');
      });
      return;
    }

    setState(() {
      _detailState = const ResourceLoading();
    });

    try {
      final viewModel = context.read<ProviderListViewModel>();
      final provider = await viewModel.getProviderById(widget.providerId);

      if (!mounted) return;

      if (provider == null) {
        setState(() {
          _detailState = const ResourceError('Provider not found.');
        });
      } else {
        setState(() {
          _detailState = ResourceSuccess(provider);
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _detailState = const ResourceError(
          'Something went wrong. Please go back and try again.',
        );
      });
    }
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRoute.home.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final child = switch (_detailState) {
      ResourceInitial() || ResourceLoading() => Scaffold(
        key: const ValueKey('loading'),
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            const AppLoadingWidget(),
            _FloatingBackButton(onBack: _handleBack),
          ],
        ),
      ),
      ResourceError(:final message) => Scaffold(
    key: const ValueKey('error'),
    backgroundColor: AppColors.background,
    body: Stack(
      children: [
        // Show specific not-found UI if the error indicates a missing provider.
        if (message.toLowerCase().contains('not found'))
          AppErrorWidget(
            title: 'Provider Not Found',
            message: message,
            actionText: 'Go Back',
            onAction: _handleBack,
          )
        else
          AppErrorWidget(
            title: 'Something Went Wrong',
            message: message,
            actionText: 'Retry',
            onAction: () {
              final vm = context.read<ProviderListViewModel>();
              vm.fetchProviders();
            },
          ),
        _FloatingBackButton(onBack: _handleBack),
      ],
    ),
  ),
      ResourceEmpty() => Scaffold(
          key: const ValueKey('empty'),
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              AppEmptyWidget(
                title: 'No Results',
                message: 'Try clearing filters.',
                icon: Icons.search_off_rounded,
                actionText: 'Clear Filters',
                onAction: () {
                  final vm = context.read<ProviderListViewModel>();
                  vm.clearAll();
                },
              ),
              _FloatingBackButton(onBack: _handleBack),
            ],
          ),
        ),
      ResourceSuccess(:final data) => Scaffold(
        key: const ValueKey('success'),
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppSizes.extraLarge),
              child: Stack(
                children: [
                  _CoverImage(provider: data),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppSizes.detailProfileCardOffset,
                      left: AppSizes.large,
                      right: AppSizes.large,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProfileInfoCard(provider: data, textTheme: textTheme),
                        const SizedBox(height: AppSizes.extraLarge),
                        _ContactCard(provider: data, textTheme: textTheme),
                        if (data.about case final about?
                            when about.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSizes.extraLarge),
                          _BioCard(
                            provider: data,
                            about: about,
                            textTheme: textTheme,
                          ),
                        ],
                        if (data.availableDays.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.extraLarge),
                          _AvailabilityCard(
                            provider: data,
                            textTheme: textTheme,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _FloatingBackButton(onBack: _handleBack),
          ],
        ),
        bottomNavigationBar: const _BookingStickyContainer(),
      ),
    };

    return AnimatedSwitcher(
      duration: AppDurations.normal,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: child,
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.provider});
  final ProviderEntity provider;

  @override
  Widget build(BuildContext context) {
    final imageUrl = provider.imageUrl;

    return SizedBox(
      width: double.infinity,
      height: AppSizes.detailCoverHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: provider.id,
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    placeholder: (context, url) => Container(
                      color: AppColors.mutedSurface,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.mutedSurface,
                      child: Icon(
                        Icons.medical_services_rounded,
                        size: AppSizes.stateIconContainerSize,
                        color: AppColors.placeholderIcon,
                      ),
                    ),
                  )
                : Container(
                    color: AppColors.mutedSurface,
                    child: Icon(
                      Icons.medical_services_rounded,
                      size: AppSizes.stateIconContainerSize,
                      color: AppColors.placeholderIcon,
                    ),
                  ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.shadowMedium.withValues(
                      alpha: AppSizes.detailImageGradientTopStop,
                    ),
                    AppColors.transparent,
                    AppColors.transparent,
                    AppColors.shadowMedium.withValues(
                      alpha: AppSizes.detailImageGradientBottomStop,
                    ),
                  ],
                  stops: AppGradients.detailImageStops,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  const _BaseCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.extraLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderLarge,
        border: Border.all(color: AppColors.border, width: AppSizes.borderThin),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium.withValues(alpha: AppShadows.alphaLow),
            blurRadius: AppShadows.blurMedium,
            offset: AppShadows.offsetMedium,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({required this.provider, required this.textTheme});
  final ProviderEntity provider;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final rating = provider.rating;

    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.isBoardCertified) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.medium,
                vertical: AppSizes.extraSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: AppRadius.borderMax,
              ),
              child: Text(
                'BOARD CERTIFIED',
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.medium),
          ],
          Text(
            '${provider.title} ${provider.name}',
            style: textTheme.headlineMedium?.copyWith(height: 1.2),
          ),
          const SizedBox(height: AppSizes.small),
          Text(
            provider.role,
            style: textTheme.titleMedium?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSizes.medium),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_rounded,
                size: AppSizes.iconSmall,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.small),
              Expanded(
                child: Text(
                  '${provider.city}${provider.hospital != null ? ' • ${provider.hospital}' : ''}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (rating != null) ...[
            const SizedBox(height: AppSizes.large),
            Row(
              children: [
                ...List.generate(5, (index) {
                  if (rating >= index + 1) {
                    return const Icon(
                      Icons.star_rounded,
                      color: AppColors.rating,
                      size: AppSizes.ratingStarSize,
                    );
                  } else if (rating > index) {
                    return const Icon(
                      Icons.star_half_rounded,
                      color: AppColors.rating,
                      size: AppSizes.ratingStarSize,
                    );
                  }
                  return const Icon(
                    Icons.star_outline_rounded,
                    color: AppColors.rating,
                    size: AppSizes.ratingStarSize,
                  );
                }),
                const SizedBox(width: AppSizes.small),
                Text(rating.toStringAsFixed(1), style: textTheme.titleMedium),
                if (provider.reviewCount != null)
                  Text(
                    ' (${provider.reviewCount} Reviews)',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.provider, required this.textTheme});
  final ProviderEntity provider;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final phone = provider.phone;
    final email = provider.email;

    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Information', style: textTheme.titleLarge),
          const SizedBox(height: AppSizes.large),
          if (phone != null)
            ContactInfoRow(
              icon: Icons.phone_rounded,
              title: 'Direct Line',
              value: phone,
            ),
          if (email != null)
            ContactInfoRow(
              icon: Icons.email_rounded,
              title: 'Official Email',
              value: email,
            ),
          if (phone == null && email == null)
            Text(
              'No contact information available.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _BioCard extends StatelessWidget {
  const _BioCard({
    required this.provider,
    required this.about,
    required this.textTheme,
  });

  final ProviderEntity provider;
  final String about;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${provider.title} ${provider.name.split(' ').last}',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSizes.large),
          Text(
            about,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          if (provider.specialties.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.stateWidgetSpacingTitle,
              ),
              child: Divider(height: AppSizes.dividerHeight),
            ),
            Text('Specialties', style: textTheme.titleMedium),
            const SizedBox(height: AppSizes.medium),
            Wrap(
              spacing: AppSizes.small,
              runSpacing: AppSizes.small,
              children: provider.specialties.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.large,
                    vertical: AppSizes.small,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mutedSurface,
                    borderRadius: AppRadius.borderMax,
                    border: Border.all(
                      color: AppColors.border,
                      width: AppSizes.borderThin,
                    ),
                  ),
                  child: Text(s.displayName, style: textTheme.labelMedium),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard({required this.provider, required this.textTheme});
  final ProviderEntity provider;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Next Available', style: textTheme.titleLarge),
              Row(
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    color: AppColors.primary,
                    size: AppSizes.iconSmall,
                  ),
                  const SizedBox(width: AppSizes.extraSmall),
                  Text(
                    'Instant Booking',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.large),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: provider.availableDays.map((day) {
                return Container(
                  margin: const EdgeInsets.only(right: AppSizes.medium),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.stateWidgetSpacingTitle,
                    vertical: AppSizes.medium,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mutedSurface,
                    borderRadius: AppRadius.borderMedium,
                    border: Border.all(
                      color: AppColors.border,
                      width: AppSizes.borderThin,
                    ),
                  ),
                  child: Text(
                    day.toUpperCase(),
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBackButton extends StatelessWidget {
  const _FloatingBackButton({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.large),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowMedium.withValues(alpha: AppShadows.alphaMedium),
                  blurRadius: AppShadows.blurSmall,
                  offset: AppShadows.offsetSmall,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primary,
                size: AppSizes.navIconSize,
              ),
              onPressed: onBack,
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingStickyContainer extends StatelessWidget {
  const _BookingStickyContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.extraLarge,
        AppSizes.large,
        AppSizes.extraLarge,
        AppSizes.huge,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border, width: AppSizes.borderThin),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium.withValues(alpha: 0.04),
            blurRadius: AppShadows.blurLarge,
            offset: AppShadows.offsetNegative,
          ),
        ],
      ),
      child: const _BookingStatefulButton(),
    );
  }
}

class _BookingStatefulButton extends StatefulWidget {
  const _BookingStatefulButton();

  @override
  State<_BookingStatefulButton> createState() => _BookingStatefulButtonState();
}

class _BookingStatefulButtonState extends State<_BookingStatefulButton> {
  bool _isLoading = false;
  bool _isReserved = false;

  void _handleBooking() async {
    if (_isReserved || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(AppDurations.booking);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isReserved = true;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Your appointment has been successfully booked!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      text: _isReserved ? 'Slot Reserved' : 'Book Appointment',
      borderRadius: AppRadius.large,
      isLoading: _isLoading,
      onPressed: _handleBooking,
    );
  }
}

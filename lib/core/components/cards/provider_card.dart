// lib/core/components/cards/provider_card.dart
//
// Card component that represents a single healthcare provider in a list.
// Fully refactored to achieve 100% Multi-Theme Reactivity and strictly enforce Design Tokens.

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medifinder/core/theme/app_colors.dart';
import 'package:medifinder/core/theme/app_sizes.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    required this.name,
    required this.specialty,
    required this.city,
    this.rating,
    this.imageUrl,
    this.heroTag,
    this.onTap,
    super.key,
  });

  final String name;
  final String specialty;
  final String city;
  final double? rating;
  final String? imageUrl;
  final String? heroTag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final rating = this.rating;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.large,
          vertical: AppSizes.cardVerticalMargin,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.borderLarge,
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: AppSizes.borderThin,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProviderAvatar(imageUrl: imageUrl, heroTag: heroTag),
              const SizedBox(width: AppSizes.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSizes.small),
                        rating != null
                            ? _RatingBadge(rating: rating)
                            : const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: AppSizes.extraSmall),
                    Text(
                      specialty,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.cityIconSpacing),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: AppSizes.iconSmall - 2.0,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSizes.miniSpacing),
                        Expanded(
                          child: Text(
                            city,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({this.imageUrl, this.heroTag});
  final String? imageUrl;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
    final heroTag = this.heroTag;
    final imageContent = imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const _AvatarPlaceholder(),
            errorWidget: (context, url, error) => const _AvatarPlaceholder(),
          )
        : const _AvatarPlaceholder();

    return ClipRRect(
      borderRadius: AppRadius.borderMedium,
      child: SizedBox(
        width: AppSizes.avatarSize,
        height: AppSizes.avatarSize,
        child: heroTag != null
            ? Hero(tag: heroTag, child: imageContent)
            : imageContent,
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Provider profile photo placeholder',
      child: Container(
        color: colorScheme.surfaceContainerHighest,
        child: Icon(Icons.person, size: 36, color: colorScheme.outline),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 14, color: AppColors.rating),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: textTheme.bodySmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

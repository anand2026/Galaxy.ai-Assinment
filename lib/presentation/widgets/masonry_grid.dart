import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/photo.dart';
import 'pin_card.dart';
import 'shimmer_loading.dart';

/// Pinterest-style masonry grid for displaying pins
/// Uses flutter_staggered_grid_view for the masonry layout
class MasonryPinGrid extends StatelessWidget {
  final List<Photo> photos;
  final ScrollController? scrollController;
  final Function(Photo photo)? onPinTap;
  final Function(Photo photo)? onPinSave;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final EdgeInsetsGeometry? padding;

  const MasonryPinGrid({
    super.key,
    required this.photos,
    this.scrollController,
    this.onPinTap,
    this.onPinSave,
    this.isLoading = false,
    this.hasMore = false,
    this.onLoadMore,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Return shimmer loading if loading with no photos
    if (photos.isEmpty && isLoading) {
      return const ShimmerLoadingScreen();
    }

    // Return empty state if no photos and not loading
    if (photos.isEmpty) {
      return const EmptyPinGrid();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Don't try to render grid if constraints are invalid
        if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
          return const SizedBox.shrink();
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                hasMore &&
                !isLoading &&
                notification.metrics.extentAfter < 300) {
              onLoadMore?.call();
            }
            return false;
          },
          child: MasonryGridView.count(
            controller: scrollController,
            crossAxisCount: AppSpacing.pinGridCrossAxisCount,
            mainAxisSpacing: AppSpacing.pinGridSpacing,
            crossAxisSpacing: AppSpacing.pinGridSpacing,
            padding:
                padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
            itemCount: photos.length + (isLoading && photos.isNotEmpty ? 2 : 0),
            itemBuilder: (context, index) {
              // Show shimmer for loading more items
              if (index >= photos.length) {
                return ShimmerPinCard(height: index.isEven ? 200 : 240);
              }

              final photo = photos[index];
              return PinCard(
                photo: photo,
                onTap: () => onPinTap?.call(photo),
                onSave: () => onPinSave?.call(photo),
              );
            },
          ),
        );
      },
    );
  }
}

/// Sliver version of masonry grid for use in CustomScrollView
class SliverMasonryPinGrid extends StatelessWidget {
  final List<Photo> photos;
  final Function(Photo photo)? onPinTap;
  final Function(Photo photo)? onPinSave;
  final bool isLoading;

  const SliverMasonryPinGrid({
    super.key,
    required this.photos,
    this.onPinTap,
    this.onPinSave,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty && isLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: ShimmerLoadingGrid(itemCount: 10),
        ),
      );
    }

    // Return empty sliver if no photos to prevent zero constraint issues
    if (photos.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: AppSpacing.pinGridCrossAxisCount,
        mainAxisSpacing: AppSpacing.pinGridSpacing,
        crossAxisSpacing: AppSpacing.pinGridSpacing,
        childCount: photos.length + (isLoading ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= photos.length) {
            return ShimmerPinCard(height: index.isEven ? 200 : 240);
          }

          final photo = photos[index];
          return PinCard(
            photo: photo,
            onTap: () => onPinTap?.call(photo),
            onSave: () => onPinSave?.call(photo),
          );
        },
      ),
    );
  }
}

/// Empty state widget for when no pins are found
class EmptyPinGrid extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const EmptyPinGrid({
    super.key,
    this.message = 'No pins found',
    this.icon = Icons.image_not_supported_outlined,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state widget
class ErrorPinGrid extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorPinGrid({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

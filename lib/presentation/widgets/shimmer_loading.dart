import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Shimmer loading placeholder for individual pin cards
class ShimmerPinCard extends StatelessWidget {
  final double height;

  const ShimmerPinCard({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.pinCardRadius),
        ),
      ),
    );
  }
}

/// Shimmer loading grid for masonry layout
class ShimmerLoadingGrid extends StatelessWidget {
  final int itemCount;
  final List<double>? heights;

  const ShimmerLoadingGrid({super.key, this.itemCount = 10, this.heights});

  @override
  Widget build(BuildContext context) {
    // Generate random-looking heights for shimmer effect
    final defaultHeights = [
      180.0,
      220.0,
      160.0,
      200.0,
      240.0,
      190.0,
      210.0,
      170.0,
      230.0,
      185.0,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column
          Expanded(
            child: Column(
              children: List.generate((itemCount / 2).ceil(), (index) {
                final heightIndex = index * 2;
                final height = heights != null && heightIndex < heights!.length
                    ? heights![heightIndex]
                    : defaultHeights[heightIndex % defaultHeights.length];
                return Padding(
                  padding: const EdgeInsets.only(
                    right: AppSpacing.xs,
                    bottom: AppSpacing.pinGridSpacing,
                  ),
                  child: ShimmerPinCard(height: height),
                );
              }),
            ),
          ),
          // Right column
          Expanded(
            child: Column(
              children: List.generate((itemCount / 2).floor(), (index) {
                final heightIndex = index * 2 + 1;
                final height = heights != null && heightIndex < heights!.length
                    ? heights![heightIndex]
                    : defaultHeights[heightIndex % defaultHeights.length];
                return Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.xs,
                    bottom: AppSpacing.pinGridSpacing,
                  ),
                  child: ShimmerPinCard(height: height),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full screen shimmer loading state
class ShimmerLoadingScreen extends StatelessWidget {
  const ShimmerLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: ShimmerLoadingGrid(itemCount: 10),
    );
  }
}

/// Shimmer for category chips
class ShimmerCategoryChip extends StatelessWidget {
  final double width;

  const ShimmerCategoryChip({super.key, this.width = 80});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
    );
  }
}

/// Shimmer for search bar
class ShimmerSearchBar extends StatelessWidget {
  const ShimmerSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
    );
  }
}

/// Shimmer for pin detail page
class ShimmerPinDetail extends StatelessWidget {
  const ShimmerPinDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: 400,
              color: AppColors.white,
            ),
            const SizedBox(height: AppSpacing.md),
            // Title placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Container(
                height: 24,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Photographer placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    height: 16,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

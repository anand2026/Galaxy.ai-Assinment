import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/photo.dart';
import '../../providers/photo_providers.dart';
import '../../widgets/masonry_grid.dart';
import '../../widgets/shimmer_loading.dart';

/// Pin detail screen showing full image and information
class PinDetailScreen extends ConsumerStatefulWidget {
  final Photo photo;

  const PinDetailScreen({super.key, required this.photo});

  @override
  ConsumerState<PinDetailScreen> createState() => _PinDetailScreenState();
}

class _PinDetailScreenState extends ConsumerState<PinDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();

    // Load related photos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(relatedPhotosProvider.notifier)
          .loadRelatedPhotos(widget.photo.alt);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSave() {
    HapticFeedback.lightImpact();
    setState(() => _isSaved = !_isSaved);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? 'Saved to board' : 'Removed from board'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return AppColors.shimmerBase;
    }
  }

  @override
  Widget build(BuildContext context) {
    final relatedPhotosState = ref.watch(relatedPhotosProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  HapticFeedback.selectionClick();
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {
                  HapticFeedback.selectionClick();
                },
              ),
            ],
          ),

          // Main Content (Image + Details)
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main image
                    Hero(
                      tag: 'photo_${widget.photo.id}',
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.pinCardRadius,
                          ),
                          child: AspectRatio(
                            aspectRatio: widget.photo.aspectRatio,
                            child: CachedNetworkImage(
                              imageUrl: widget.photo.src.large2x,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: _parseColor(widget.photo.avgColor),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: _parseColor(widget.photo.avgColor),
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                              },
                              icon: const Icon(Icons.link),
                              label: const Text('Visit'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _handleSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isSaved
                                    ? AppColors.textPrimary
                                    : AppColors.primary,
                              ),
                              child: Text(_isSaved ? 'Saved' : 'Save'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Title and description
                    if (widget.photo.alt.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Text(
                          widget.photo.alt,
                          style: AppTypography.headlineMedium,
                        ),
                      ),

                    const SizedBox(height: AppSpacing.md),

                    // Photographer info
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.surfaceVariant,
                            child: Text(
                              widget.photo.photographer.isNotEmpty
                                  ? widget.photo.photographer[0].toUpperCase()
                                  : '?',
                              style: AppTypography.titleLarge.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.photo.photographer,
                                  style: AppTypography.titleMedium,
                                ),
                                Text(
                                  'on Pexels',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                            },
                            child: const Text('Follow'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),

                    // 'More like this' Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Text(
                        'More like this',
                        style: AppTypography.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),

          // Related Photos Grid
          relatedPhotosState.when(
            data: (photos) {
              if (photos.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverMasonryPinGrid(
                photos: photos,
                onPinTap: (photo) {
                  ref.read(selectedPhotoProvider.notifier).state = photo;
                  context.push('/pin/${photo.id}', extra: photo);
                },
                onPinSave: (photo) {
                  // Handle save
                },
              );
            },
            loading: () => SliverBox(child: ShimmerLoadingGrid(itemCount: 6)),
            error: (_, __) =>
                const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}

class SliverBox extends StatelessWidget {
  final Widget child;
  const SliverBox({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: child);
  }
}

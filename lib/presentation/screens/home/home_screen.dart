import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/photo_providers.dart';
import '../../widgets/masonry_grid.dart';
import '../../widgets/shimmer_loading.dart';

/// Home screen with masonry grid of curated photos
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load initial photos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeFeedProvider.notifier).loadPhotos();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(homeFeedProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderPill(
              text: 'All',
              isSelected: _selectedTabIndex == 0,
              onTap: () => setState(() => _selectedTabIndex = 0),
            ),
            const SizedBox(width: 8),
            _HeaderPill(
              text: 'For You',
              isSelected: _selectedTabIndex == 1,
              onTap: () => setState(() => _selectedTabIndex = 1),
            ),
          ],
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(HomeFeedState state) {
    if (state.error != null && state.photos.isEmpty) {
      return ErrorPinGrid(
        message: state.error!,
        onRetry: () => ref.read(homeFeedProvider.notifier).loadPhotos(),
      );
    }

    if (state.isLoading && state.photos.isEmpty) {
      return const ShimmerLoadingScreen();
    }

    if (state.photos.isEmpty) {
      return EmptyPinGrid(
        message: 'No photos available',
        onRetry: () => ref.read(homeFeedProvider.notifier).loadPhotos(),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: MasonryPinGrid(
        photos: state.photos,
        scrollController: _scrollController,
        isLoading: state.isLoadingMore,
        hasMore: state.hasMore,
        onLoadMore: () => ref.read(homeFeedProvider.notifier).loadMore(),
        onPinTap: (photo) {
          ref.read(selectedPhotoProvider.notifier).state = photo;
          context.push('/pin/${photo.id}', extra: photo);
        },
        onPinSave: (photo) {
          // Handle save
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Saved "${photo.alt.isNotEmpty ? photo.alt : 'Photo'}"',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _HeaderPill({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

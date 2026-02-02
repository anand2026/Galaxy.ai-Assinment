import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/photo_providers.dart';
import '../../widgets/masonry_grid.dart';
import '../../widgets/search_widgets.dart';
import '../../widgets/shimmer_loading.dart';

/// Search screen with Pinterest-style browse categories
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;

  // Static Pinterest-style categories with colors
  final List<Map<String, dynamic>> _browseCategories = [
    {'name': 'Nature', 'color': const Color(0xFF4B6F44)},
    {'name': 'Architecture', 'color': const Color(0xFF6B5B95)},
    {'name': 'Food', 'color': const Color(0xFFD65076)},
    {'name': 'Travel', 'color': const Color(0xFF009B77)},
    {'name': 'Fashion', 'color': const Color(0xFF92A8D1)},
    {'name': 'Art', 'color': const Color(0xFFE9897E)},
    {'name': 'Animals', 'color': const Color(0xFFA52A2A)},
    {'name': 'Tech', 'color': const Color(0xFF45B8AC)},
    {'name': 'Decor', 'color': const Color(0xFFEFC050)},
    {'name': 'Quotes', 'color': const Color(0xFF5B5EA6)},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    ref.read(searchProvider.notifier).search(query.trim());
    _focusNode.unfocus();
    setState(() => _isSearching = true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar (Fixed at top)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: PinterestSearchBar(
                controller: _searchController,
                focusNode: _focusNode,
                hintText: 'Search for ideas',
                onChanged: (value) {
                  // Optional: Real-time search or clear
                  if (value.isEmpty && _isSearching) {
                    setState(() => _isSearching = false);
                  }
                },
                onSubmitted: _onSearch,
                onTap: () {
                  // Just focus, don't necessarily change state until typing
                },
              ),
            ),

            // Expanded Content
            Expanded(
              child: _isSearching
                  ? _buildSearchResults(state)
                  : _buildBrowseGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseGrid() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ideas for you', style: AppTypography.headlineSmall),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.6, // Rectangular cards
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final category = _browseCategories[index];
              return _BrowseCard(
                name: category['name'] as String,
                color: category['color'] as Color,
                onTap: () {
                  _searchController.text = category['name'] as String;
                  _onSearch(category['name'] as String);
                },
              );
            }, childCount: _browseCategories.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
      ],
    );
  }

  Widget _buildSearchResults(SearchState state) {
    if (state.isLoading && state.photos.isEmpty) {
      return const ShimmerLoadingScreen();
    }

    if (state.error != null && state.photos.isEmpty) {
      return ErrorPinGrid(
        message: state.error!,
        onRetry: () => ref.read(searchProvider.notifier).search(state.query),
      );
    }

    if (state.photos.isEmpty && state.query.isNotEmpty) {
      return Center(
        child: Text(
          'No results found for "${state.query}"',
          style: AppTypography.bodyLarge,
        ),
      );
    }

    // Pass the scroll controller if needed for pagination
    return MasonryPinGrid(
      photos: state.photos,
      isLoading: state.isLoadingMore,
      hasMore: state.hasMore,
      onLoadMore: () => ref.read(searchProvider.notifier).loadMore(),
      onPinTap: (photo) {
        ref.read(selectedPhotoProvider.notifier).state = photo;
      },
      onPinSave: (photo) {},
    );
  }
}

class _BrowseCard extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onTap;

  const _BrowseCard({
    required this.name,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.2),
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            name,
            style: AppTypography.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

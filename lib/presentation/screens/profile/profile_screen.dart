import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Profile screen with user info and boards
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                pinned: true,
                expandedHeight: 320,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(background: _ProfileHeader()),
                bottom: TabBar(
                  indicatorColor: Colors.transparent, // Hide default underline
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColors.textPrimary,
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.textPrimary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 8,
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                  tabs: const [
                    Tab(height: 40, text: 'Created'),
                    Tab(height: 40, text: 'Saved'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Created tab
              _BoardsGrid(isCreated: true),
              // Saved tab
              _BoardsGrid(isCreated: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.surfaceVariant,
            child: Text(
              'U',
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Name
          Text('Pinterest User', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.xs),

          // Username
          Text(
            '@pinterestuser',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatItem(label: 'followers', count: '0'),
              const SizedBox(width: AppSpacing.xl),
              _StatItem(label: 'following', count: '0'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String count;

  const _StatItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: AppTypography.titleLarge),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}

class _BoardsGrid extends StatefulWidget {
  final bool isCreated;

  const _BoardsGrid({required this.isCreated});

  @override
  State<_BoardsGrid> createState() => _BoardsGridState();
}

class _BoardsGridState extends State<_BoardsGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Preserve scroll position when switching tabs

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    // Placeholder boards
    final boards = widget.isCreated
        ? [
            {
              'name': 'My Pins',
              'urls': [
                'https://images.pexels.com/photos/3225517/pexels-photo-3225517.jpeg?auto=compress&cs=tinysrgb&h=350',
                'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&h=350',
                'https://images.pexels.com/photos/1005644/pexels-photo-1005644.jpeg?auto=compress&cs=tinysrgb&h=350',
              ],
            },
            {
              'name': 'Ideas',
              'urls': [
                'https://images.pexels.com/photos/207962/pexels-photo-207962.jpeg?auto=compress&cs=tinysrgb&h=350',
              ],
            },
          ]
        : [
            {
              'name': 'Travel',
              'urls': [
                'https://images.pexels.com/photos/3278215/pexels-photo-3278215.jpeg?auto=compress&cs=tinysrgb&h=350',
                'https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?auto=compress&cs=tinysrgb&h=350',
                'https://images.pexels.com/photos/346885/pexels-photo-346885.jpeg?auto=compress&cs=tinysrgb&h=350',
              ],
            },
            {
              'name': 'Food',
              'urls': [
                'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&h=350',
              ],
            },
            {'name': 'Fashion', 'urls': []},
          ];

    if (boards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.isCreated
                  ? Icons.add_circle_outline
                  : Icons.bookmark_border,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.isCreated
                  ? 'Create your first Pin!'
                  : 'Save Pins to see them here',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.85, // Taller for cover + text
      ),
      itemCount: boards.length + 1, // +1 for create board button
      itemBuilder: (context, index) {
        if (index == 0 && widget.isCreated) {
          return _CreateBoardCard();
        }
        final boardIndex = widget.isCreated ? index - 1 : index;
        if (boardIndex >= boards.length) {
          return _CreateBoardCard();
        }
        final board = boards[boardIndex];
        return _BoardCard(
          name: board['name'] as String,
          imageUrls: board['urls'] as List<String>,
        );
      },
    );
  }
}

class _BoardCard extends StatelessWidget {
  final String name;
  final List<String> imageUrls;

  const _BoardCard({required this.name, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Container(
              color: AppColors.surfaceVariant,
              child: _buildCover(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypography.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${imageUrls.isEmpty ? 0 : imageUrls.length * 5 + 2} Pins', // Fake count
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCover() {
    if (imageUrls.isEmpty) {
      return const Center(
        child: Icon(Icons.grid_view, size: 32, color: AppColors.textSecondary),
      );
    }

    if (imageUrls.length < 3) {
      // Single image cover
      return CachedNetworkImage(
        imageUrl: imageUrls[0],
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorWidget: (_, __, ___) => const SizedBox(),
      );
    }

    // Collage: 1 large left, 2 small right
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CachedNetworkImage(
            imageUrl: imageUrls[0],
            fit: BoxFit.cover,
            height: double.infinity,
            errorWidget: (_, __, ___) => const SizedBox(),
          ),
        ),
        const SizedBox(width: 1),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: imageUrls[1],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorWidget: (_, __, ___) => const SizedBox(),
                ),
              ),
              const SizedBox(height: 1),
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: imageUrls[2],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorWidget: (_, __, ___) => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CreateBoardCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 32, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.sm),
            Text('Create board', style: AppTypography.titleSmall),
          ],
        ),
      ),
    );
  }
}

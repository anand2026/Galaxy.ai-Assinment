import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';

/// Pinterest-style search bar widget
/// Features rounded design with search icon and clear button
class PinterestSearchBar extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final bool autofocus;
  final bool readOnly;
  final FocusNode? focusNode;

  const PinterestSearchBar({
    super.key,
    this.hintText = 'Search for ideas',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  State<PinterestSearchBar> createState() => _PinterestSearchBarState();
}

class _PinterestSearchBarState extends State<PinterestSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _clearText() {
    HapticFeedback.selectionClick();
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        style: AppTypography.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTypography.searchHint,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 24,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: _clearText,
                )
              : IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    // Visual search placeholder
                  },
                ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12,
          ),
        ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
      ),
    );
  }
}

/// Search suggestions list widget
class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;
  final bool showRecent;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
    this.showRecent = false,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRecent) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              'Recent searches',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
        ...suggestions.map(
          (suggestion) => _SuggestionItem(
            text: suggestion,
            onTap: () {
              HapticFeedback.selectionClick();
              onSuggestionTap(suggestion);
            },
            showRecent: showRecent,
          ),
        ),
      ],
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool showRecent;

  const _SuggestionItem({
    required this.text,
    required this.onTap,
    this.showRecent = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              showRecent ? Icons.history : Icons.search,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(text, style: AppTypography.bodyMedium)),
            if (showRecent)
              Icon(Icons.north_west, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// Trending search topics grid
class TrendingTopics extends StatelessWidget {
  final List<TrendingTopic> topics;
  final Function(TrendingTopic) onTopicTap;

  const TrendingTopics({
    super.key,
    required this.topics,
    required this.onTopicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text('Ideas for you', style: AppTypography.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < topics.length - 1 ? AppSpacing.sm : 0,
                ),
                child: _TopicCard(
                  topic: topic,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTopicTap(topic);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TrendingTopic {
  final String name;
  final String imageUrl;

  const TrendingTopic({required this.name, required this.imageUrl});
}

class _TopicCard extends StatelessWidget {
  final TrendingTopic topic;
  final VoidCallback onTap;

  const _TopicCard({required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          image: DecorationImage(
            image: NetworkImage(topic.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, const Color.fromRGBO(0, 0, 0, 0.6)],
            ),
          ),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            topic.name,
            style: AppTypography.labelMedium.copyWith(color: AppColors.white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// Category chips row
class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String) onCategoryTap;

  const CategoryChips({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return Padding(
            padding: EdgeInsets.only(
              right: index < categories.length - 1 ? AppSpacing.sm : 0,
            ),
            child: _CategoryChip(
              label: category,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                onCategoryTap(category);
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

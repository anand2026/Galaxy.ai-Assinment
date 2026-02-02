import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Pinterest-style bottom navigation bar
/// Features clean icons without labels, matching Pinterest's minimalist design
class PinterestBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PinterestBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.pinShadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                icon: CupertinoIcons.house_fill,
                isSelected: currentIndex == 0,
                onTap: () => _handleTap(0),
              ),
              _NavItem(
                icon: CupertinoIcons.search,
                isSelected: currentIndex == 1,
                onTap: () => _handleTap(1),
              ),
              _NavItem(
                icon: Icons.add,
                isSelected: currentIndex == 2,
                onTap: () => _handleTap(2),
                isCreate: true,
              ),
              _NavItem(
                icon: CupertinoIcons.chat_bubble_fill,
                isSelected: currentIndex == 3,
                onTap: () => _handleTap(3),
              ),
              _NavItem(
                icon: CupertinoIcons.person_fill,
                isSelected: currentIndex == 4,
                onTap: () => _handleTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(int index) {
    HapticFeedback.selectionClick();
    onTap(index);
  }
}

/// Individual navigation item
class _NavItem extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCreate;

  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isCreate = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: widget.isCreate
              ? BoxDecoration(
                  color: widget.isSelected
                      ? AppColors.textPrimary
                      : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                )
              : null,
          child: Icon(
            widget.icon,
            size: 28,
            color: widget.isCreate
                ? (widget.isSelected ? AppColors.white : AppColors.textPrimary)
                : (widget.isSelected
                      ? AppColors.navActive
                      : AppColors.navInactive),
          ),
        ),
      ),
    );
  }
}

/// Pinterest-style floating action button for create
class PinterestFAB extends StatefulWidget {
  final VoidCallback onTap;

  const PinterestFAB({super.key, required this.onTap});

  @override
  State<PinterestFAB> createState() => _PinterestFABState();
}

class _PinterestFABState extends State<PinterestFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.pinShadow,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: AppColors.white, size: 28),
        ),
      ),
    );
  }
}

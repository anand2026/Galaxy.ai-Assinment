import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/photo.dart';

/// Pinterest-style pin card widget
/// Displays an image with rounded corners, hover/tap overlay with save button
class PinCard extends StatefulWidget {
  final Photo photo;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool showOverlay;

  const PinCard({
    super.key,
    required this.photo,
    this.onTap,
    this.onSave,
    this.showOverlay = true,
  });

  @override
  State<PinCard> createState() => _PinCardState();
}

class _PinCardState extends State<PinCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isSaved = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  void _handleSave() {
    HapticFeedback.lightImpact();
    setState(() {
      _isSaved = !_isSaved;
    });
    widget.onSave?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onLongPress: () => _showLongPressMenu(context),
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap?.call();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image container
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.pinCardRadius),
                child: Stack(
                  children: [
                    // Main image
                    AspectRatio(
                      aspectRatio: widget.photo.aspectRatio,
                      child: Container(
                        color: _parseColor(widget.photo.avgColor),
                        child: CachedNetworkImage(
                          imageUrl: widget.photo.src.medium,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: _parseColor(widget.photo.avgColor),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: _parseColor(widget.photo.avgColor),
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          fadeInDuration: const Duration(milliseconds: 200),
                          fadeOutDuration: const Duration(milliseconds: 200),
                        ),
                      ),
                    ),

                    // Hover/tap overlay
                    if (widget.showOverlay)
                      Positioned.fill(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isHovered ? 1.0 : 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color.fromRGBO(0, 0, 0, 0.0),
                                  const Color.fromRGBO(0, 0, 0, 0.3),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Save button - always visible on mobile, hover on desktop
                    if (widget.showOverlay)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isHovered || _isMobile(context) ? 1.0 : 0.0,
                          child: _SaveButton(
                            isSaved: _isSaved,
                            onTap: _handleSave,
                          ),
                        ),
                      ),

                    // More options button
                    if (widget.showOverlay)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isHovered ? 1.0 : 0.0,
                          child: _IconButton(
                            icon: Icons.more_horiz,
                            onTap: () {
                              HapticFeedback.selectionClick();
                            },
                          ),
                        ),
                      ),

                    // Share button
                    if (widget.showOverlay)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isHovered ? 1.0 : 0.0,
                          child: _IconButton(
                            icon: Icons.share_outlined,
                            onTap: () {
                              HapticFeedback.selectionClick();
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Pin info (title and photographer)
              if (widget.photo.alt.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    widget.photo.alt,
                    style: AppTypography.pinTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              // Photographer info
              if (widget.photo.photographer.isNotEmpty) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.surfaceVariant,
                        child: Text(
                          widget.photo.photographer[0].toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.photo.photographer,
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
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

  bool _isMobile(BuildContext context) {
    // Check if the device is touch-based (mobile/tablet)
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
  }

  void _showLongPressMenu(BuildContext context) {
    HapticFeedback.mediumImpact();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, _, __) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MenuIconAction(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {
                      Navigator.pop(context);
                      // Share logic
                    },
                  ),
                  const SizedBox(width: 24),
                  _MenuIconAction(
                    icon: Icons.bookmark_border,
                    label: 'Save',
                    onTap: () {
                      Navigator.pop(context);
                      _handleSave();
                    },
                  ),
                  const SizedBox(width: 24),
                  _MenuIconAction(
                    icon: Icons.visibility_off_outlined,
                    label: 'Hide',
                    onTap: () {
                      Navigator.pop(context);
                      // Hide logic
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MenuIconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuIconAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}

/// Pinterest-style save button
class _SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const _SaveButton({required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSaved ? AppColors.textPrimary : AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Text(
          isSaved ? 'Saved' : 'Save',
          style: AppTypography.labelLarge.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}

/// Small icon button for overlay actions
class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';

class CreateBottomSheet extends StatelessWidget {
  const CreateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle/Close
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text(
            'Create',
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CreateOption(
                icon: Icons.push_pin_outlined,
                label: 'Pin',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Pin Creator or pick image
                },
              ),
              _CreateOption(
                icon: Icons.dashboard_customize_outlined,
                label: 'Board',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Board Creator
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          // Cancel button
          Center(
            child: IconButton(
              icon: const Icon(Icons.close, size: 32),
              onPressed: () => Navigator.pop(context),
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _CreateOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CreateOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, size: 32, color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppTypography.labelLarge),
        ],
      ),
    );
  }
}

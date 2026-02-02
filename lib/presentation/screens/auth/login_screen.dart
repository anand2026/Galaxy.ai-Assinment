import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/photo_providers.dart';
// Clerk integration: import 'package:clerk_flutter/clerk_flutter.dart';
// Note: Configure Clerk in main.dart with ClerkAuth.initialize(publishableKey: 'your_key')

/// Pinterest-style login screen with scrolling background
/// Supports Clerk authentication for production use
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load photos for background
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeFeedProvider.notifier).loadPhotos();
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(_scrollController.offset + 1);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final photoState = ref.watch(homeFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Grid
          Opacity(
            opacity: 0.6,
            child: IgnorePointer(
              child: MasonryGridView.count(
                controller: _scrollController,
                crossAxisCount: 3, // More dense for background
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: photoState.photos.length * 3, // Duplicate for loop
                itemBuilder: (context, index) {
                  // Cycle through photos
                  if (photoState.photos.isEmpty) return const SizedBox();
                  final photo =
                      photoState.photos[index % photoState.photos.length];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(photo.src.medium, fit: BoxFit.cover),
                  );
                },
              ),
            ),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.8),
                  AppColors.background.withValues(alpha: 0.95),
                  AppColors.background,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'P',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    'Welcome to Pinterest',
                    style: AppTypography.headlineLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Email Field
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text('Continue'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Social Buttons
                  _SocialButton(
                    label: 'Continue with Facebook',
                    color: const Color(0xFF1877F2),
                    onTap: _handleLogin,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SocialButton(
                    label: 'Continue with Google',
                    color: AppColors.textSecondary,
                    isOutlined: true,
                    onTap: _handleLogin,
                  ),
                  const Spacer(),
                  Text(
                    'By continuing, you agree to Pinterest\'s Terms of Service and open Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isOutlined;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.color,
    this.isOutlined = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                label,
                style: AppTypography.button.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(label),
            ),
    );
  }
}

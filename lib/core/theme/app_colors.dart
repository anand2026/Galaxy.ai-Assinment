import 'package:flutter/material.dart';

/// Pinterest-inspired color palette
/// These colors are derived from the official Pinterest app design system
class AppColors {
  AppColors._();

  // Primary brand color - Pinterest Red
  static const Color primary = Color(0xFFE60023);
  static const Color primaryDark = Color(0xFFAD081B);
  static const Color primaryLight = Color(0xFFFF5252);

  // Background colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9F9F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text colors
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF767676);
  static const Color textTertiary = Color(0xFFB3B3B3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border and divider colors
  static const Color border = Color(0xFFEFEFEF);
  static const Color divider = Color(0xFFDADADA);

  // Interactive states
  static const Color hover = Color(0xFFF0F0F0);
  static const Color pressed = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFCCCCCC);

  // Semantic colors
  static const Color success = Color(0xFF00A651);
  static const Color error = Color(0xFFE60023);
  static const Color warning = Color(0xFFFFBD00);
  static const Color info = Color(0xFF0076D3);

  // Overlay colors
  static const Color overlayLight = Color(0x1A000000);
  static const Color overlayMedium = Color(0x4D000000);
  static const Color overlayDark = Color(0x80000000);

  // Shimmer colors
  static const Color shimmerBase = Color(0xFFE8E8E8);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Bottom navigation
  static const Color navActive = Color(0xFF111111);
  static const Color navInactive = Color(0xFF767676);

  // Card and pin colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color pinShadow = Color(0x1A000000);

  // Black and white
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

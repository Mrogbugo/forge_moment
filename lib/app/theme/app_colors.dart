import 'package:flutter/material.dart';

// Material Design 3 colour tokens — extracted from Stitch design system.
// Do NOT change these values without updating the Stitch source first.
class AppColors {
  AppColors._();

  // ── Primary (deep rose/pink) ─────────────────────────────────────────────
  static const Color primary = Color(0xFFB80049);
  static const Color primaryContainer = Color(0xFFE2155F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFFBFF);
  static const Color onPrimaryFixed = Color(0xFF400014);
  static const Color onPrimaryFixedVariant = Color(0xFF900038);
  static const Color inversePrimary = Color(0xFFFFB2BE);
  static const Color primaryFixed = Color(0xFFFFD9DE);
  static const Color primaryFixedDim = Color(0xFFFFB2BE);

  // ── Secondary (gold/amber) ───────────────────────────────────────────────
  static const Color secondary = Color(0xFF705D00);
  static const Color secondaryContainer = Color(0xFFFCD400);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF6E5C00);
  static const Color secondaryFixed = Color(0xFFFFE16D);
  static const Color secondaryFixedDim = Color(0xFFE9C400);
  static const Color onSecondaryFixed = Color(0xFF221B00);
  static const Color onSecondaryFixedVariant = Color(0xFF544600);

  // ── Tertiary (sage green) ────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF575E53);
  static const Color tertiaryContainer = Color(0xFF70776B);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFF8FFF0);
  static const Color tertiaryFixed = Color(0xFFDEE5D7);
  static const Color tertiaryFixedDim = Color(0xFFC2C9BB);
  static const Color onTertiaryFixed = Color(0xFF171D15);
  static const Color onTertiaryFixedVariant = Color(0xFF42493E);

  // ── Error ────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Surface / Background ─────────────────────────────────────────────────
  static const Color background = Color(0xFFF9F9F9);
  static const Color onBackground = Color(0xFF1A1C1C);
  static const Color surface = Color(0xFFF9F9F9);
  static const Color onSurface = Color(0xFF1A1C1C);
  static const Color surfaceVariant = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFF5B3F43);
  static const Color surfaceTint = Color(0xFFBC004B);
  static const Color surfaceBright = Color(0xFFF9F9F9);
  static const Color surfaceDim = Color(0xFFDADADA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F3F4);
  static const Color surfaceContainer = Color(0xFFEEEEEE);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E8);
  static const Color surfaceContainerHighest = Color(0xFFE2E2E2);

  // ── Inverse ──────────────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF2F3131);
  static const Color inverseOnSurface = Color(0xFFF0F1F1);

  // ── Outline ──────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF8F6F73);
  static const Color outlineVariant = Color(0xFFE4BDC2);

  // ── Brand tokens (Stitch login screen additions) ─────────────────────────
  // brand-deep-rose is used for primary CTAs (slightly more vibrant than primary).
  static const Color brandDeepRose = Color(0xFFC2185B);
  static const Color brandBlushPink = Color(0xFFF8BBD0);

  // ── Nigeria-specific ─────────────────────────────────────────────────────
  static const Color nairaGreen = Color(0xFF008751);
}

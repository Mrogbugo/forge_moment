import 'package:flutter/material.dart';

// Typography system — all roles use Montserrat (bundled via pubspec.yaml).
class AppTextStyles {
  AppTextStyles._();

  // ── Display LG — Montserrat 48/56 w600 ls-0.02em ────────────────────────
  static const TextStyle displayLg = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 56 / 48,
    letterSpacing: 48 * -0.02,
  );

  // ── Headline LG — Montserrat 32/40 w600 ─────────────────────────────────
  static const TextStyle headlineLg = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
  );

  // ── Headline LG Mobile — Montserrat 28/36 w600 ──────────────────────────
  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
  );

  // ── Headline MD — Montserrat 24/32 w500 ─────────────────────────────────
  static const TextStyle headlineMd = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
  );

  // ── Body LG — Montserrat 18/28 w400 ─────────────────────────────────────
  static const TextStyle bodyLg = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  // ── Body MD — Montserrat 16/24 w400 ─────────────────────────────────────
  static const TextStyle bodyMd = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  // ── Label MD — Montserrat 14/20 w600 ls+0.01em ──────────────────────────
  static const TextStyle labelMd = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 14 * 0.01,
  );

  // ── Currency Display — Montserrat 32/40 w700 ls-0.03em ───────────────────
  static const TextStyle currencyDisplay = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: 32 * -0.03,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // ── Colour scheme (exact M3 tokens from Stitch) ─────────────────────────
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.inverseOnSurface,
    inversePrimary: AppColors.inversePrimary,
    surfaceTint: AppColors.surfaceTint,
  );

  // ── Base text style used for all slots not covered by AppTextStyles ──────
  static const _base = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
  );

  // ── Text theme ───────────────────────────────────────────────────────────
  static final TextTheme _textTheme = TextTheme(
    displayLarge: AppTextStyles.displayLg,
    displayMedium: _base.copyWith(fontSize: 45, fontWeight: FontWeight.w400, height: 52 / 45),
    displaySmall: _base.copyWith(fontSize: 36, fontWeight: FontWeight.w400, height: 44 / 36),
    headlineLarge: AppTextStyles.headlineLg,
    headlineMedium: AppTextStyles.headlineLgMobile,
    headlineSmall: AppTextStyles.headlineMd,
    titleLarge: AppTextStyles.currencyDisplay,
    titleMedium: _base.copyWith(fontSize: 16, fontWeight: FontWeight.w500, height: 24 / 16, letterSpacing: 0.15),
    titleSmall: _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, height: 20 / 14, letterSpacing: 0.1),
    bodyLarge: AppTextStyles.bodyLg,
    bodyMedium: AppTextStyles.bodyMd,
    bodySmall: _base.copyWith(fontSize: 12, fontWeight: FontWeight.w400, height: 16 / 12, letterSpacing: 0.4),
    labelLarge: AppTextStyles.labelMd,
    labelMedium: _base.copyWith(fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12, letterSpacing: 0.5),
    labelSmall: _base.copyWith(fontSize: 11, fontWeight: FontWeight.w500, height: 16 / 11, letterSpacing: 0.5),
  );

  // ── Light theme ──────────────────────────────────────────────────────────
  static final ThemeData light = ThemeData(
        useMaterial3: true,
        colorScheme: _lightColorScheme,
        scaffoldBackgroundColor: AppColors.background,
        // Ensures every Text widget not covered by the text theme still renders
        // in Montserrat with the bundled fallback applied automatically.
        fontFamily: 'Montserrat',
        fontFamilyFallback: const ['Montserrat Fallback'],
        textTheme: _textTheme,

        // System UI overlay — light status bar for the light-background screens
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.onBackground,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: AppTextStyles.headlineMd
              .copyWith(color: AppColors.onBackground),
        ),

        // Primary CTA button — matches the Stitch "Get Started" style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            textStyle: AppTextStyles.labelMd,
            minimumSize: const Size(double.infinity, 56),
            shape: const StadiumBorder(), // rounded-full
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
        ),

        // Outlined / secondary button
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.labelMd,
            minimumSize: const Size(double.infinity, 56),
            shape: const StadiumBorder(),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),

        // Text button — login link, etc.
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.labelMd,
          ),
        ),

        // Input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: AppTextStyles.bodyMd
              .copyWith(color: AppColors.onSurfaceVariant),
        ),

        // Card
        cardTheme: CardThemeData(
          color: AppColors.surfaceContainerLowest,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),

        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainerLow,
          labelStyle: AppTextStyles.labelMd
              .copyWith(color: AppColors.onSurfaceVariant),
          shape: const StadiumBorder(),
          side: const BorderSide(color: AppColors.outlineVariant),
        ),

        // Bottom nav
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surfaceContainerLowest,
          indicatorColor: AppColors.primaryFixed,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.onPrimaryFixed);
            }
            return const IconThemeData(color: AppColors.onSurfaceVariant);
          }),
          labelTextStyle: WidgetStateProperty.all(AppTextStyles.labelMd),
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.inverseSurface,
          contentTextStyle: AppTextStyles.bodyMd
              .copyWith(color: AppColors.inverseOnSurface),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineVariant,
          thickness: 0.5,
        ),
      );

  // ── Dark theme (to be expanded post-MVP) ────────────────────────────────
  static final ThemeData dark = light; // fallback to light until dark tokens are defined
}

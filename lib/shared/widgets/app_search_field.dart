import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Canonical search field matching the Forge Moments design spec:
/// pill shape · white background · outlineVariant border · italic placeholder
/// · search icon left · Montserrat font.
///
/// Usage:
/// ```dart
/// AppSearchField(
///   controller: _ctrl,
///   hintText: 'Search by name or number...',
///   onChanged: (v) { … },
/// )
/// ```
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search by name or number...',
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.search,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontFamilyFallback: const ['Montserrat Fallback'],
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 15,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: AppColors.outline,
        ),
      ),
    );
  }
}

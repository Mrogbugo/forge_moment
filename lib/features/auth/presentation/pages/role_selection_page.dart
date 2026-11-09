import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage>
    with TickerProviderStateMixin {
  // Selected role: null = nothing picked yet
  _Role? _selected;

  // Blob animations
  late final AnimationController _blob1;
  late final AnimationController _blob2;
  late final Animation<double> _blob1Scale;
  late final Animation<double> _blob1X;
  late final Animation<double> _blob2Scale;
  late final Animation<double> _blob2X;

  @override
  void initState() {
    super.initState();

    _blob1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _blob2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _blob1Scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _blob1, curve: Curves.easeInOut));

    _blob1X = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _blob1, curve: Curves.easeInOut),
    );

    _blob2Scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.10), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.10, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _blob2, curve: Curves.easeInOut));

    _blob2X = Tween<double>(begin: 0, end: -24).animate(
      CurvedAnimation(parent: _blob2, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _blob1.dispose();
    _blob2.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_selected == null) return;
    if (_selected == _Role.gifter) {
      context.go(AppRoutes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vendor portal is coming soon. Stay tuned!',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],fontSize: 14),
          ),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Blob 1 — top-left ─────────────────────────────────────────────
          AnimatedBuilder(
            animation: _blob1,
            builder: (_, __) => Positioned(
              top: -size.height * 0.08,
              left: -size.width * 0.12 + _blob1X.value,
              child: Transform.scale(
                scale: _blob1Scale.value,
                child: _Blob(
                  size: size.width * 0.75,
                  color: AppColors.inversePrimary.withAlpha(64),
                ),
              ),
            ),
          ),

          // ── Blob 2 — bottom-right ─────────────────────────────────────────
          AnimatedBuilder(
            animation: _blob2,
            builder: (_, __) => Positioned(
              bottom: -size.height * 0.10,
              right: -size.width * 0.15 + _blob2X.value,
              child: Transform.scale(
                scale: _blob2Scale.value,
                child: _Blob(
                  size: size.width * 0.80,
                  color: AppColors.primaryContainer.withAlpha(51),
                ),
              ),
            ),
          ),

          // ── Main content ──────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, topPad > 0 ? 12 : 24, 20, bottomPad + 16),
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo / wordmark
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.card_giftcard_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Forge Moments',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Frosted glass card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withAlpha(230),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: AppColors.outlineVariant.withAlpha(77),
                            width: 0.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How will you use\nForge Moments?',
                              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Choose your role to get the right experience.',
                              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 15,
                                color: AppColors.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Role cards
                            _RoleCard(
                              role: _Role.gifter,
                              icon: Icons.redeem_rounded,
                              title: 'I\'m a Gifter',
                              description:
                                  'Send personalized gifts, money packages and airtime surprises to the people you love.',
                              isSelected: _selected == _Role.gifter,
                              badge: null,
                              onTap: () =>
                                  setState(() => _selected = _Role.gifter),
                            ),
                            const SizedBox(height: 16),
                            _RoleCard(
                              role: _Role.vendor,
                              icon: Icons.storefront_rounded,
                              title: 'I\'m a Vendor',
                              description:
                                  'List your products and reach thousands of gifters looking for the perfect gift.',
                              isSelected: _selected == _Role.vendor,
                              badge: 'Coming Soon',
                              onTap: () =>
                                  setState(() => _selected = _Role.vendor),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _selected != null ? _onContinue : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.outlineVariant.withAlpha(80),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: AppColors.onSurfaceVariant,
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Role enum ─────────────────────────────────────────────────────────────────

enum _Role { gifter, vendor }

// ── Role card ─────────────────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  final _Role role;
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(13)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withAlpha(26)
                    : AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 26,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.onSurface,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 13,
                      height: 1.5,
                      color: isSelected
                          ? AppColors.primary.withAlpha(180)
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Blob ──────────────────────────────────────────────────────────────────────

class _Blob extends StatelessWidget {
  final double size;
  final Color color;

  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 80, spreadRadius: 60),
        ],
      ),
    );
  }
}

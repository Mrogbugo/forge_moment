import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom-navigation shell matching the Stitch Home Dashboard design:
/// Home · Cart · Store (centre FAB) · Gifts · Account
///
/// The centre FAB floats 24 px above the bar — replicated with a Stack and
/// clipBehavior: Clip.none inside [_StitchNavBar].
///
/// Scaffold uses extendBody: true so the body content can scroll behind the
/// nav bar; each page's ScrollView adds bottom padding of
/// `MediaQuery.paddingOf(context).bottom + 88` (bar height) to compensate.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: _StitchNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: true,
        ),
      ),
    );
  }
}

// ── Stitch Nav Bar ────────────────────────────────────────────────────────────

class _StitchNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _StitchNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    // Total height: 24 px (FAB overflow) + 64 px (bar items) + system safe area
    const barHeight = 64.0;
    const fabOverflow = 24.0;
    final totalHeight = fabOverflow + barHeight + bottom;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // ── Bar background + nav items ──────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: barHeight + bottom,
            child: Container(
              decoration: BoxDecoration(
                color: _AppNavColors.surface,
                border: Border(
                  top: BorderSide(
                    color: _AppNavColors.outlineVariant,
                    width: 0.5,
                  ),
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.only(bottom: bottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _NavItem(
                    outlinedIcon: Icons.home_outlined,
                    filledIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                  _NavItem(
                    outlinedIcon: Icons.shopping_cart_outlined,
                    filledIcon: Icons.shopping_cart,
                    label: 'Cart',
                    index: 1,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                  // Placeholder space for centre FAB
                  const SizedBox(width: 64),
                  _NavItem(
                    outlinedIcon: Icons.favorite_border,
                    filledIcon: Icons.favorite,
                    label: 'Wishlist',
                    index: 3,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                  _NavItem(
                    outlinedIcon: Icons.person_outline,
                    filledIcon: Icons.person,
                    label: 'Account',
                    index: 4,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),

          // ── Centre FAB — Stores, floats 24 px above bar ─────────────────
          Positioned(
            top: 0, // top of SizedBox = 24 px above bar top
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => onTap(2),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: currentIndex == 2
                            ? _AppNavColors.primary
                            : _AppNavColors.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _AppNavColors.surface,
                          width: 4,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33B80049),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.storefront_outlined,
                        color: _AppNavColors.onPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Stores',
                    style: _AppNavColors.navLabel.copyWith(
                      color: currentIndex == 2
                          ? _AppNavColors.primary
                          : _AppNavColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual nav item ────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData outlinedIcon;
  final IconData filledIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.outlinedIcon,
    required this.filledIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 14 : 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isActive ? _AppNavColors.primaryFixed : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? filledIcon : outlinedIcon,
              size: 24,
              color: isActive
                  ? _AppNavColors.primary
                  : _AppNavColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: _AppNavColors.navLabel.copyWith(
                color: isActive
                    ? _AppNavColors.primary
                    : _AppNavColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Inline colour tokens (avoids importing AppColors directly into router layer)
// These must match AppColors exactly.
abstract final class _AppNavColors {
  static const surface = Color(0xFFF9F9F9);
  static const primary = Color(0xFFB80049);
  static const primaryContainer = Color(0xFFE2155F);
  static const primaryFixed = Color(0xFFFFD9DE);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSurfaceVariant = Color(0xFF5B3F43);
  static const outlineVariant = Color(0xFFE4BDC2);

  // Cached nav label base — color applied via copyWith to avoid per-build allocation.
  static const TextStyle navLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: ['Montserrat Fallback'],
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}

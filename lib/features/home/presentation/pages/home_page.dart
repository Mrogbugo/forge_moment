import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

// ---------------------------------------------------------------------------
// Cached text styles — computed once, never recreated on rebuild.
// ---------------------------------------------------------------------------

abstract final class _HomeStyles {
  static final TextStyle caption = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const ['Montserrat Fallback'],
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );
  static final TextStyle balance = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const ['Montserrat Fallback'],
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: 32 * -0.01,
    color: AppColors.primary,
  );
  static final TextStyle sponsoredLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const ['Montserrat Fallback'],
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF6C614E),
    letterSpacing: 11 * 0.05,
  );
  static final TextStyle sponsoredSubtitle = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const ['Montserrat Fallback'],
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xE5FFFFFF),
  );
  static final TextStyle gridLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const ['Montserrat Fallback'],
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
    height: 1.3,
  );
  static final TextStyle celebrationDate = TextStyle(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const ['Montserrat Fallback'],
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
}

// ---------------------------------------------------------------------------
// Static data
// ---------------------------------------------------------------------------

const _avatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuC35Nu5mfg8YqnGguwsZk58NVGRZxMPD4YQkr1Xhh1tZnXZwiT2PTi8ZdVF2wcC-Bc_D48-jrd-yVoBtPts0GwL7cJNyBgGc85emX_iLmmr3rNRdv76TtHLTj_xDn7XTmGJNzrUX04oi8SXL3iPhcFIGsX_sWFWOfoo9agSK3wrUSMQtyA0SNSEt5oCMxDqYc_hIdBMYaayB8_qbjuk4IeppRyareOd1J7uSJ-bt4Jkg9-0AV6CwdNRnQ';

const _sponsoredImages = [
  'https://lh3.googleusercontent.com/aida-public/AB6AXuBroKD-otHkdYDFxJ16o2HzK_llDa6C4Vn3yLeNqY4Pgrb-vMMPkAIrALEdyMdOc6SfD8CZ6br31_FSvFBqe4CUipsiY5JjkP0zOSO07bUyjTHBvYhdIiL7pJkunGcbnOXtFKf5gf_FQ2_0IeHzh8loovXYodtSWjVmnE-NmMbL6zzOKwMIAquE3fDXk-z3QlNR4LBTSMBKUFQ9ADwspdnLPU2NeIjSWLD1VWetqTr-ann-uTnfWsk9rAACuEIq9xckkoU',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuAOBYDDF0_06_4mDXC3fSF2LzzBKkJIYSd3Y-8LqF-I5QNM6m1tRrKc2MkNlo40-2OMiFiGkEEC9E6mBDO5WH82u08P9LDmZEZqnMwVEi1ZZlYruryKf063-Kfk4y8GH7FcN4jsv0NFItsXb8KQe3loH7Nlk4uK2yQ-0nSoDLMUnAN_bkWlIehdmXChyUz_auaXYb5FMNggmaiLhzDFWYMX3szRPx6nEKca7CM5YHycZQUgRuYaaxHf9w',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuDtwJTHSwrMIXxzm5NZSFcM-AMNvZS70RpgO_hVlOhdS_m_5Kcrx5nF4oDCh9TTK7WMVOc92KKR6W7LZXnA4L7KpEuNuSuDr9sgVClzM5M73-MCun6srpbIhzBfadg2GmCy9FbR-BVIMmxHjrMfKA-f4pLxGf2PEo_0zbQ-NSkGnUptwPu5SxOxANLNvN_ZHX3fDmStdNIsqNF1qaMx26-IVAmr8SAOxAuOeTkIR2SwlzqE2RyZwIVW-A',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuAEuJh-0Yhfaw5oZxV9Yh8YAgxfzGeamiqhwb2oJLbaLzdrGQlEOV9EuERQkmQZSpe_YoUPk95vmiVgPIGHr_aVBnhY49WmoUjya252LtPj07wRTBCdhucJNu3ROkR_qMvmijMlvbOeC9gWu0hWJy5Q2EugY8Cvmc9c4H6sbZUeuYcMsj3YTmgpoizlJ0g_ZkMiCRuH4bJrX2qVMllMtqWZEbna5bwa0ssLNlVYuSJPucWbyIAbSbWLWA',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuBIeOLk6kqfOGBAyg3EwcXj134-ujns6FHcPKaeMCVLZaf6VZBxrvMFOUUb8wP4CvDGX-UB6HQSEsQfD2j0w0GVPBhy9BFbonAGd8_6qp8Ch-1QtDikwiSQ5_Obkj-vtrqJWrPBQ2lGDEJPBYVC8VWkhKQ2N9xqIRkEYUWNN0AmMSKUa4OxbzyrKGXPofbHJ1wdnm8Fjfl9RjxASXRKl0CFX2J_lUbzhBa6uJQP4Jc2kjwezW_o78x2Ng',
];

class _GridAction {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final String route;

  const _GridAction({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.route,
  });
}

const _gridActions = [
  _GridAction(
    icon: Icons.card_giftcard,
    label: 'Digital Gift',
    bgColor: Color(0x80F0E0C8),
    iconColor: Color(0xFF685D4A),
    route: AppRoutes.createDigitalGift,
  ),
  _GridAction(
    icon: Icons.storefront,
    label: 'Browse',
    bgColor: AppColors.surfaceContainerHigh,
    iconColor: AppColors.tertiary,
    route: AppRoutes.store,
  ),
  _GridAction(
    icon: Icons.favorite,
    label: 'Wishlist',
    bgColor: Color(0x4DFFD9DE), // primaryFixed / 30%
    iconColor: AppColors.primary,
    route: AppRoutes.gifts,
  ),
  _GridAction(
    icon: Icons.receipt_long,
    label: 'Orders',
    bgColor: AppColors.surfaceContainerHigh,
    iconColor: AppColors.tertiary,
    route: AppRoutes.orders,
  ),
];

// ---------------------------------------------------------------------------
// HomePage
// ---------------------------------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _carouselController;
  Timer? _carouselTimer;
  int _currentSlide = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = PageController();
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentSlide + 1) % _sponsoredImages.length;
      _carouselController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _DashboardAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 88,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _WalletCard(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SponsoredCarousel(
                controller: _carouselController,
                currentSlide: _currentSlide,
                onPageChanged: (i) => setState(() => _currentSlide = i),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _QuickActionsSection(),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _UpcomingCelebrations(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DashboardAppBar
// ---------------------------------------------------------------------------

class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DashboardAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          decoration: const BoxDecoration(
            color: Color(0xB3F9F9F9), // surface / 70%
            border: Border(
              bottom: BorderSide(color: Color(0x14000000), width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryFixed, width: 2),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: _avatarUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.primaryFixed,
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.primaryFixed,
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Greeting text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Evening,',
                    style: _HomeStyles.caption,
                  ),
                  Text(
                    'Stanley',
                    style: AppTextStyles.headlineMd.copyWith(
                      color: AppColors.primary,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Notification bell with badge
              SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        shape: BoxShape.circle,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () =>
                              context.push(AppRoutes.notifications),
                          child: const Icon(
                            Icons.notifications_outlined,
                            size: 22,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _WalletCard  (glass morphism)
// ---------------------------------------------------------------------------

class _WalletCard extends StatelessWidget {
  const _WalletCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer container carries the luxury shadow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1ABA0037), // primary / 10%
            blurRadius: 40,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xB3FFFFFF), // white / 70%
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x66FFFFFF)), // white / 40%
            ),
            child: Stack(
              children: [
                // Decorative glow orb (top-right, clipped by parent ClipRRect)
                const Positioned(
                  right: -40,
                  top: -40,
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0x4DFFB2BE), // primaryFixedDim / 30%
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 18,
                                color: AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Forge Wallet',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Available balance',
                              style: _HomeStyles.caption,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Balance — display-lg-mobile equivalent
                      Text.rich(
                        TextSpan(
                          style: _HomeStyles.balance,
                          children: const [
                            TextSpan(
                              text: '₦',
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                            TextSpan(text: '250,000.00'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    context.push(AppRoutes.fundWallet),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Money'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: AppTextStyles.labelMd,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    context.push(AppRoutes.wallet),
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                ),
                                label: const Text('View Wallet'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: AppTextStyles.labelMd,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SponsoredCarousel
// ---------------------------------------------------------------------------

class _SponsoredCarousel extends StatelessWidget {
  final PageController controller;
  final int currentSlide;
  final ValueChanged<int> onPageChanged;

  const _SponsoredCarousel({
    required this.controller,
    required this.currentSlide,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26BA0037), // primary / 15%
            blurRadius: 40,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 2.0,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Slide images
              PageView.builder(
                controller: controller,
                itemCount: _sponsoredImages.length,
                onPageChanged: onPageChanged,
                itemBuilder: (_, i) => CachedNetworkImage(
                  imageUrl: _sponsoredImages[i],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const _PrimaryGradientBox(),
                  errorWidget: (_, __, ___) => const _PrimaryGradientBox(),
                ),
              ),
              // Bottom gradient
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 0.65],
                    colors: [Color(0xCC000000), Colors.transparent],
                  ),
                ),
              ),
              // Sponsored badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDDEC5), // design: secondary-container
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: const Color(0x80EDDEC5)),
                  ),
                  child: Text(
                    'SPONSORED',
                    style: _HomeStyles.sponsoredLabel,
                  ),
                ),
              ),
              // Bottom info + CTA
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Curated Collection',
                              style: _HomeStyles.sponsoredSubtitle,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Premium Gifts',
                              style: AppTextStyles.headlineLg.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.store),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Shop Now',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PrimaryGradientBox  (placeholder / error fallback)
// ---------------------------------------------------------------------------

class _PrimaryGradientBox extends StatelessWidget {
  const _PrimaryGradientBox();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD9DE), Color(0xFFE2155F)],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _QuickActionsSection
// ---------------------------------------------------------------------------

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (int i = 0; i < _gridActions.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: _GridActionItem(action: _gridActions[i]),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _GridActionItem
// ---------------------------------------------------------------------------

class _GridActionItem extends StatelessWidget {
  final _GridAction action;

  const _GridActionItem({required this.action});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.push(action.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: action.bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(action.icon, size: 18, color: action.iconColor),
              ),
              const SizedBox(height: 4),
              Text(
                action.label,
                style: _HomeStyles.gridLabel,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _UpcomingCelebrations
// ---------------------------------------------------------------------------

class _UpcomingCelebrations extends StatelessWidget {
  const _UpcomingCelebrations();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Upcoming Celebrations',
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            GestureDetector(
              onTap: () => context.push(AppRoutes.celebrations),
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _CelebrationCard(
          name: "Sarah's Birthday",
          date: 'Oct 12',
          avatarChild: Text(
            'S',
            style: AppTextStyles.headlineMd.copyWith(
              color: const Color(0xFF221B0B), // design: on-secondary-fixed
            ),
          ),
          avatarBg: const Color(0xFFF0E0C8), // design: secondary-fixed
          onEdit: () => context.push(AppRoutes.createGift),
        ),
        const SizedBox(height: 8),
        _CelebrationCard(
          name: 'Wedding Anniversary',
          date: 'Oct 15',
          avatarChild: const Icon(
            Icons.favorite,
            size: 22,
            color: AppColors.onSurfaceVariant,
          ),
          avatarBg: AppColors.surfaceContainerHighest,
          onEdit: () => context.push(AppRoutes.createGift),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _CelebrationCard
// ---------------------------------------------------------------------------

class _CelebrationCard extends StatelessWidget {
  final String name;
  final String date;
  final Widget avatarChild;
  final Color avatarBg;
  final VoidCallback onEdit;

  const _CelebrationCard({
    required this.name,
    required this.date,
    required this.avatarChild,
    required this.avatarBg,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: avatarBg,
              shape: BoxShape.circle,
            ),
            child: Center(child: avatarChild),
          ),
          const SizedBox(width: 16),
          // Name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.event, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: _HomeStyles.celebrationDate,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Edit button
          Material(
            color: const Color(0x4DFFD9DE), // primaryFixed / 30%
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onEdit,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

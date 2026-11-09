import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../blocs/onboarding_cubit.dart';

// ---------------------------------------------------------------------------
// Slide data
// ---------------------------------------------------------------------------

class _Slide {
  final String imageAsset;
  final String headline;
  final String subtitle;
  const _Slide({
    required this.imageAsset,
    required this.headline,
    required this.subtitle,
  });
}

const _slides = [
  _Slide(
    imageAsset: 'assets/images/onboarding_1.jpg',
    headline: 'Create Moments\nThat Last Forever',
    subtitle:
        'Send personalized gifts, cash, and airtime with a touch of magic and Forge AI.',
  ),
  _Slide(
    imageAsset: 'assets/images/onboarding_2.jpg',
    headline: 'Group Together,\nGive Together',
    subtitle:
        'Pool airtime, cash and gifts with friends for someone truly special.',
  ),
  _Slide(
    imageAsset: 'assets/images/onboarding_3.jpg',
    headline: 'Never Miss\nWhat Matters Most',
    subtitle:
        'Set reminders for birthdays and anniversaries. Forge Moments has your back.',
  ),
];

// ---------------------------------------------------------------------------
// OnboardingPage
// ---------------------------------------------------------------------------

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late final OnboardingCubit _cubit;
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  // Monotonically increasing counter used as AnimatedSwitcher keys so that
  // revisiting a page (e.g. auto-play wrapping 2→0) never produces duplicate
  // keys inside AnimatedSwitcher's internal Stack.
  int _transitionId = 0;

  // Float: image card bobs up/down 10px over 6 s
  late final AnimationController _floatController;
  late final Animation<double> _floatAnim;

  // Shimmer: highlight sweeps across the primary button
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnim;

  // Pulse: active dot breathes between scale 1.0 → 1.15
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_cubit.state.currentPage + 1) % _slides.length;
      _changePage(next);
    });
  }

  void _changePage(int page) {
    setState(() => _transitionId++);
    _cubit.goToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _cubit = OnboardingCubit();
    _pageController = PageController();
    _startAutoPlay();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    // Goes from -2 → 2; used as the x-centre of a LinearGradient Alignment
    _shimmerAnim = Tween<double>(begin: -2, end: 2).animate(_shimmerController);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _cubit.close();
    _pageController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    authNotifier.setOnboarded(true);
    context.go(AppRoutes.roleSelection);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (ctx, state) {
          if (state.isCompleted) {
            _autoPlayTimer?.cancel();
            _goToLogin();
          } else {
            // Sync PageView whenever the cubit page changes
            if (_pageController.hasClients &&
                _pageController.page?.round() != state.currentPage) {
              _pageController.animateToPage(
                state.currentPage,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          }
        },
        builder: (ctx, state) {
          final slide = _slides[state.currentPage];
          final isLast = state.currentPage == _slides.length - 1;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: Stack(
              children: [
                // ── Decorative background blobs (top-left + bottom-right) ──
                Positioned(
                  top: -size.height * 0.10,
                  left: -size.width * 0.10,
                  child: _Blob(
                    width: size.width * 0.50,
                    height: size.height * 0.50,
                    color: AppColors.inversePrimary.withAlpha(77),
                  ),
                ),
                Positioned(
                  bottom: -size.height * 0.10,
                  right: -size.width * 0.10,
                  child: _Blob(
                    width: size.width * 0.60,
                    height: size.height * 0.60,
                    color: AppColors.outlineVariant.withAlpha(51),
                  ),
                ),

                // ── Main layout ────────────────────────────────────────────
                Column(
                  children: [
                    // ── Image section (flex-1) ─────────────────────────────
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          topPad + 24,
                          20,
                          0,
                        ),
                        child: AnimatedBuilder(
                          animation: _floatAnim,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(0, _floatAnim.value),
                            child: child,
                          ),
                          child: _ImageCard(
                            pageController: _pageController,
                            onPageChanged: (i) {
                              _changePage(i);
                              _startAutoPlay(); // reset timer after manual swipe
                            },
                          ),
                        ),
                      ),
                    ),

                    // ── Text + Actions section ─────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 32, 20, bottomPad + 40),
                      child: Column(
                        children: [
                          // Dots
                          _DotIndicator(
                            count: _slides.length,
                            current: state.currentPage,
                            pulseAnim: _pulseAnim,
                          ),

                          const SizedBox(height: 32),

                          // Headline — animates between slides
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.1),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            ),
                            child: Text(
                              slide.headline,
                              key: ValueKey(_transitionId),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                                letterSpacing: -0.02 * 40,
                                color: AppColors.onSurface,
                              ),
                              textAlign: TextAlign.center,

                            ),
                          ),

                          const SizedBox(height: 16),

                          // Subtitle — animates between slides
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: Text(
                              slide.subtitle,
                              key: ValueKey('sub_$_transitionId'),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                color: AppColors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Primary CTA — Get Started / Next
                          _ShimmerButton(
                            shimmerAnim: _shimmerAnim,
                            label: isLast ? 'Get Started' : 'Next',
                            onPressed: () => _cubit.nextPage(),
                          ),

                          const SizedBox(height: 16),

                          // Secondary link — Log In
                          GestureDetector(
                            onTap: _goToLogin,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Log In to existing account',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontFamilyFallback: const ['Montserrat Fallback'],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.01 * 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ImageCard  — swipeable PageView inside the floating card
// ---------------------------------------------------------------------------

class _ImageCard extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  const _ImageCard({required this.pageController, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.outlineVariant.withAlpha(77),
            width: 0.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26E61A61), // rgba(230,26,97,0.15)
              blurRadius: 40,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Swipeable images
            PageView.builder(
              controller: pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: onPageChanged,
              itemCount: _slides.length,
              itemBuilder: (_, i) => Image.asset(
                _slides[i].imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _GradientPlaceholder(),
              ),
            ),

            // Bottom-to-top gradient overlay (fades image into background)
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 0.45],
                  colors: [Color(0xE6F9F9F9), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _GradientPlaceholder
// ---------------------------------------------------------------------------

class _GradientPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryFixed, AppColors.primaryContainer],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DotIndicator
// ---------------------------------------------------------------------------

class _DotIndicator extends StatelessWidget {
  final int count;
  final int current;
  final Animation<double> pulseAnim;

  const _DotIndicator({
    required this.count,
    required this.current,
    required this.pulseAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        if (isActive) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, __) => Transform.scale(
                scaleX: pulseAnim.value,
                child: Container(
                  width: 32,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant.withAlpha(128),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// _ShimmerButton  — primary rose button with sweeping highlight
// ---------------------------------------------------------------------------

class _ShimmerButton extends StatelessWidget {
  final Animation<double> shimmerAnim;
  final String label;
  final VoidCallback onPressed;

  const _ShimmerButton({
    required this.shimmerAnim,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4DB80049),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Sweeping shimmer overlay
            AnimatedBuilder(
              animation: shimmerAnim,
              builder: (_, __) {
                final dx = shimmerAnim.value; // -2 → 2
                return Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(dx - 1, 0),
                        end: Alignment(dx + 1, 0),
                        colors: [
                          Colors.transparent,
                          Colors.white.withAlpha(51),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Label + arrow icon
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.01 * 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _Blob  — decorative blurred circle accent
// ---------------------------------------------------------------------------

class _Blob extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _Blob({required this.width, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 60,
          ),
        ],
      ),
    );
  }
}

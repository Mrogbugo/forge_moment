import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_search_field.dart';
import '../../domain/repositories/store_repository.dart';
import '../blocs/store_cubit.dart';

// ---------------------------------------------------------------------------
// Static data
// ---------------------------------------------------------------------------

class _ProductData {
  final String name;
  final String price;
  final String imageUrl;
  final bool isBestseller;
  final String vendor;
  final double rating;
  final int reviewCount;
  final String location;
  final bool sameDay;

  const _ProductData({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.isBestseller = false,
    required this.vendor,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.sameDay,
  });
}

const _products = [
  _ProductData(
    name: 'Eternal Bloom',
    price: '₦85k',
    isBestseller: true,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuADhfEk658rXrYh-IwmRaYplrbQgri60ziu1wm6h9cTjiPXjjDkRneIoP0MQZHtxwZvnk-2eNvhd71hufvf0-MUi28o8E8r5kAL7EfS-yXlONltU3JmMzR4PjR1k1AyUAI9Li8OLGcxWGb93iSmiS5eCKmMs-r8vl29QyBocNzrIgw6FZk3LrMT0OCPTdVB-gy1Z8aTxqXdvtHe8xmmBlm1ngru272cax04GvQ4PxAcpVqQSl1CGtUcGw',
    vendor: 'LuxeBloom Lagos',
    rating: 4.8,
    reviewCount: 124,
    location: 'VI, Lagos',
    sameDay: true,
  ),
  _ProductData(
    name: 'Truffles',
    price: '₦45k',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAzyT65xUrPGO1-flw1shW8JtkPFJ1XsewoCp3gVhMUwOanU2yxGBisMUWCuZuK3qOFiHiQPcz9K48A0XsQcara57D9HzJP3nJanZhC8FGYC782Sj8wFEW8eW6TyjcBCfF6PWGsHCuQoQ_Y0hbb78vSpAvchZYqt_Q19NeWvd60Wq8tUXZfTlFyGL_S5ej7ih6VT7jtREVPEWC5pZvWZLHjkvF3bD4RNyUAHe5Qq4xtA6byNhdKNnFnrI7A',
    vendor: 'Choco Artisans',
    rating: 4.5,
    reviewCount: 89,
    location: 'Ikoyi, Lagos',
    sameDay: false,
  ),
  _ProductData(
    name: 'Golden Hour',
    price: '₦120k',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC2zI6D_Z2ViFCRN_3Nb4XIZRQRMIlO1_tgLP-y85ZHV4itfphT8qE2c7U2QnWwGUtt7wht8R0vGbM1STJZT8s0T76JovqXIuJDE7VzgH4Q3mSn3fPQPmj66fSTSd3X5TD7f4IEoUf8c8GLxdUPaBXPEQf6ztVT8iN4vYQAjDFi8BMBkh6uxTUdpfIuG_TPsuOnkKY5iIJlmvbuR2Si1BLHEgcO97R1THSBgFlFNEyiUa8kxWq6r1LeQQ',
    vendor: 'GoldCraft NG',
    rating: 4.9,
    reviewCount: 201,
    location: 'Lekki, Lagos',
    sameDay: true,
  ),
  _ProductData(
    name: 'Spa Retreat',
    price: '₦65k',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA10NZlqWKpUZ7yF3BQpdK2QTiXj49cZkanWLWSg9mxfn6M27nNi2GI20AOzU0GMkFfVq-652UV6-4tdc0ipBOMEeuewlRl7n5EoFTgv61xFKD1SoeG6LmReKZaHCxXF5Gwt_KbTz8X1rJecn04B5_UAUOZKUI0OZJdFz0Bp7Yh_SMhDOFq3MYK9vDRsWIlLM4PGl-fCmunc9bJw3wnXPD823GoscMYYI8q1ZZOoK4h1bIOk7e93lPxjA',
    vendor: 'Serene Wellness',
    rating: 4.7,
    reviewCount: 56,
    location: 'Abuja (FCT)',
    sameDay: true,
  ),
];

// Carousel images — same curated set as the home screen Premium Gifts banner.
const _carouselImages = [
  'https://lh3.googleusercontent.com/aida-public/AB6AXuBroKD-otHkdYDFxJ16o2HzK_llDa6C4Vn3yLeNqY4Pgrb-vMMPkAIrALEdyMdOc6SfD8CZ6br31_FSvFBqe4CUipsiY5JjkP0zOSO07bUyjTHBvYhdIiL7pJkunGcbnOXtFKf5gf_FQ2_0IeHzh8loovXYodtSWjVmnE-NmMbL6zzOKwMIAquE3fDXk-z3QlNR4LBTSMBKUFQ9ADwspdnLPU2NeIjSWLD1VWetqTr-ann-uTnfWsk9rAACuEIq9xckkoU',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuAOBYDDF0_06_4mDXC3fSF2LzzBKkJIYSd3Y-8LqF-I5QNM6m1tRrKc2MkNlo40-2OMiFiGkEEC9E6mBDO5WH82u08P9LDmZEZqnMwVEi1ZZlYruryKf063-Kfk4y8GH7FcN4jsv0NFItsXb8KQe3loH7Nlk4uK2yQ-0nSoDLMUnAN_bkWlIehdmXChyUz_auaXYb5FMNggmaiLhzDFWYMX3szRPx6nEKca7CM5YHycZQUgRuYaaxHf9w',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuDtwJTHSwrMIXxzm5NZSFcM-AMNvZS70RpgO_hVlOhdS_m_5Kcrx5nF4oDCh9TTK7WMVOc92KKR6W7LZXnA4L7KpEuNuSuDr9sgVClzM5M73-MCun6srpbIhzBfadg2GmCy9FbR-BVIMmxHjrMfKA-f4pLxGf2PEo_0zbQ-NSkGnUptwPu5SxOxANLNvN_ZHX3fDmStdNIsqNF1qaMx26-IVAmr8SAOxAuOeTkIR2SwlzqE2RyZwIVW-A',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuAEuJh-0Yhfaw5oZxV9Yh8YAgxfzGeamiqhwb2oJLbaLzdrGQlEOV9EuERQkmQZSpe_YoUPk95vmiVgPIGHr_aVBnhY49WmoUjya252LtPj07wRTBCdhucJNu3ROkR_qMvmijMlvbOeC9gWu0hWJy5Q2EugY8Cvmc9c4H6sbZUeuYcMsj3YTmgpoizlJ0g_ZkMiCRuH4bJrX2qVMllMtqWZEbna5bwa0ssLNlVYuSJPucWbyIAbSbWLWA',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuBIeOLk6kqfOGBAyg3EwcXj134-ujns6FHcPKaeMCVLZaf6VZBxrvMFOUUb8wP4CvDGX-UB6HQSEsQfD2j0w0GVPBhy9BFbonAGd8_6qp8Ch-1QtDikwiSQ5_Obkj-vtrqJWrPBQ2lGDEJPBYVC8VWkhKQ2N9xqIRkEYUWNN0AmMSKUa4OxbzyrKGXPofbHJ1wdnm8Fjfl9RjxASXRKl0CFX2J_lUbzhBa6uJQP4Jc2kjwezW_o78x2Ng',
];

// ---------------------------------------------------------------------------
// StorePage  (BLoC shell — keeps DI wiring for when real data lands)
// ---------------------------------------------------------------------------

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StoreCubit(repository: GetIt.instance<StoreRepository>()),
      child: const _StoreView(),
    );
  }
}

// ---------------------------------------------------------------------------
// _StoreView
// ---------------------------------------------------------------------------

class _StoreView extends StatefulWidget {
  const _StoreView();

  @override
  State<_StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<_StoreView> {
  final Set<int> _wishlisted = {};
  String _sortBy = 'Recommended';

  static const _sortOptions = [
    'Recommended',
    'Most Popular',
    'Newest Gifts',
    'Price: Low to High',
    'Highest Rated',
  ];

  void _showSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Sort by',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              ..._sortOptions.map((option) {
                final isSelected = option == _sortBy;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(
                    option,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary, size: 18)
                      : null,
                  onTap: () {
                    setState(() => _sortBy = option);
                    Navigator.of(ctx).pop();
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _StoreAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            _buildSearchBar(),
            // AI Concierge banner
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _AIConciergeCard(),
            ),
            // Filter row — below "Find the perfect gift"
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  Text(
                    '${_products.length} gifts available',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.storeFilter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.tune,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Sort row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Sort by: ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _sortBy,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showSortSheet,
                    child: const Icon(
                      Icons.expand_more,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Product grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _products.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.48,
                ),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return _ProductCard(
                    product: product,
                    wishlisted: _wishlisted.contains(index),
                    onWishlist: () => setState(() {
                      if (_wishlisted.contains(index)) {
                        _wishlisted.remove(index);
                      } else {
                        _wishlisted.add(index);
                      }
                    }),
                    onAdd: () {},
                    onTap: () => context.push(
                      '/store/${product.name.toLowerCase().replaceAll(' ', '-')}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: AppSearchField(
        hintText: 'Search gifts, vendors, occasions and experiences',
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _StoreAppBar
// ---------------------------------------------------------------------------

class _StoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _StoreAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 0),
          decoration: const BoxDecoration(
            color: Color(0xB3F9F9F9),
            border: Border(
              bottom: BorderSide(color: Color(0x14000000), width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Back button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.canPop(context)
                        ? context.pop()
                        : context.go(AppRoutes.home),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Title
              Text(
                'All Gifts',
                style: AppTextStyles.headlineMd.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
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
// _AIConciergeCard  — auto-scrolling carousel (mirrors home SponsoredCarousel)
// ---------------------------------------------------------------------------

class _AIConciergeCard extends StatefulWidget {
  const _AIConciergeCard();

  @override
  State<_AIConciergeCard> createState() => _AIConciergeCardState();
}

class _AIConciergeCardState extends State<_AIConciergeCard> {
  // Total slides = 1 text intro + photos
  int get _totalSlides => 1 + _carouselImages.length;

  late final PageController _ctrl;
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_current + 1) % _totalSlides;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  // Slide 0 — text intro (replaces the first image slide)
  Widget _buildTextSlide() {
    return Container(
      color: const Color(0xFFFBF6EF),
      child: Stack(
        children: [
          // Decorative glow blob (top-right)
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0x33FFB2BE),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Text content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AI Concierge badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x1ABA0037),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome,
                          size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'AI Concierge',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find the perfect gift',
                  style: AppTextStyles.headlineLg
                      .copyWith(color: AppColors.onSurface),
                ),
                const SizedBox(height: 6),
                Text(
                  'Not sure what to buy? Let our AI suggest personalized, premium gifts in seconds.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only show photo-slide overlays when on a photo slide (index > 0)
    final bool isPhotoSlide = _current > 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26BA0037),
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
              // PageView: slide 0 = text intro, slides 1+ = photos
              PageView.builder(
                controller: _ctrl,
                itemCount: _totalSlides,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) {
                  if (i == 0) return _buildTextSlide();
                  return CachedNetworkImage(
                    imageUrl: _carouselImages[i - 1],
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const _StoreGradientPlaceholder(),
                    errorWidget: (_, __, ___) => const _StoreGradientPlaceholder(),
                  );
                },
              ),
              // Dark gradient + overlays — only on photo slides
              if (isPhotoSlide) ...[
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
                // AI CONCIERGE badge — top left
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDDEC5),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(color: const Color(0x80EDDEC5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome,
                            size: 12, color: Color(0xFF6C614E)),
                        const SizedBox(width: 4),
                        Text(
                          'AI CONCIERGE',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6C614E),
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom text + CTA
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
                                'Not sure what to buy?',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontFamilyFallback: const ['Montserrat Fallback'],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xE5FFFFFF),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Find the perfect gift',
                                style: AppTextStyles.headlineLg
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.aiConcierge),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Ask AI Now',
                                  style: AppTextStyles.labelMd
                                      .copyWith(color: AppColors.primary),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward,
                                    size: 16, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreGradientPlaceholder extends StatelessWidget {
  const _StoreGradientPlaceholder();

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
// _ProductCard
// ---------------------------------------------------------------------------

class _ProductCard extends StatelessWidget {
  final _ProductData product;
  final bool wishlisted;
  final VoidCallback onWishlist;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.wishlisted,
    required this.onWishlist,
    required this.onAdd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1ABA0037),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xD9FFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceContainerHigh),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section
                  Expanded(
                    flex: 6,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: AppColors.surfaceContainerLow),
                        CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: AppColors.surfaceContainerLow,
                          ),
                          errorWidget: (_, __, ___) => const _GradientBox(),
                        ),
                        // Bottom overlay pills
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Row(
                            children: [
                              // Verified Vendor pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Text(
                                  '✓ Verified Vendor',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontFamilyFallback: const ['Montserrat Fallback'],
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (product.sameDay) ...[
                                const SizedBox(width: 4),
                                // Same Day pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Text(
                                    'Same Day',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontFamilyFallback: const ['Montserrat Fallback'],
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Info section
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Verified forge vendor badge row
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 11,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'VERIFIED FORGE VENDOR',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Product name
                        Text(
                          product.name,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Vendor name
                        Text(
                          product.vendor,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Price
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                            children: [
                              const TextSpan(
                                text: '₦',
                                style: TextStyle(fontFamily: 'Roboto'),
                              ),
                              TextSpan(
                                text: product.price.replaceFirst('₦', ''),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Rating row
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Color(0xFFFFA500),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating} (${product.reviewCount})',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 10,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Location row
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 11,
                              color: AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                product.location,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontFamilyFallback: const ['Montserrat Fallback'],
                                  fontSize: 10,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Add to Moment button
                        SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: onAdd,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.zero,
                              textStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Add to Moment'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _GradientBox  (image placeholder / error fallback)
// ---------------------------------------------------------------------------

class _GradientBox extends StatelessWidget {
  const _GradientBox();

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

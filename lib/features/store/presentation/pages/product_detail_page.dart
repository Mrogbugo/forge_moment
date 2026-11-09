import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

// ---------------------------------------------------------------------------
// Static mock detail data keyed by productId slug
// ---------------------------------------------------------------------------

class _ProductDetail {
  final String name;
  final String vendor;
  final double rating;
  final int reviewCount;
  final String price;
  final String rawPrice;
  final String description;
  final String location;
  final bool sameDay;
  final List<String> imageUrls;

  const _ProductDetail({
    required this.name,
    required this.vendor,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.rawPrice,
    required this.description,
    required this.location,
    this.sameDay = false,
    required this.imageUrls,
  });
}

const _details = <String, _ProductDetail>{
  'eternal-bloom': _ProductDetail(
    name: 'Eternal Bloom',
    vendor: 'LuxeBloom Lagos',
    rating: 4.8,
    reviewCount: 124,
    price: '₦85,000',
    rawPrice: '₦85,000',
    description:
        'A luxurious preserved rose arrangement that lasts up to 3 years without water. '
        'Each stem is hand-selected and treated with an eco-friendly preserving solution '
        'that locks in beauty and fragrance — the perfect timeless gift.',
    location: 'Victoria Island, Lagos',
    sameDay: true,
    imageUrls: [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuADhfEk658rXrYh-IwmRaYplrbQgri60ziu1wm6h9cTjiPXjjDkRneIoP0MQZHtxwZvnk-2eNvhd71hufvf0-MUi28o8E8r5kAL7EfS-yXlONltU3JmMzR4PjR1k1AyUAI9Li8OLGcxWGb93iSmiS5eCKmMs-r8vl29QyBocNzrIgw6FZk3LrMT0OCPTdVB-gy1Z8aTxqXdvtHe8xmmBlm1ngru272cax04GvQ4PxAcpVqQSl1CGtUcGw',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAOBYDDF0_06_4mDXC3fSF2LzzBKkJIYSd3Y-8LqF-I5QNM6m1tRrKc2MkNlo40-2OMiFiGkEEC9E6mBDO5WH82u08P9LDmZEZqnMwVEi1ZZlYruryKf063-Kfk4y8GH7FcN4jsv0NFItsXb8KQe3loH7Nlk4uK2yQ-0nSoDLMUnAN_bkWlIehdmXChyUz_auaXYb5FMNggmaiLhzDFWYMX3szRPx6nEKca7CM5YHycZQUgRuYaaxHf9w',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDtwJTHSwrMIXxzm5NZSFcM-AMNvZS70RpgO_hVlOhdS_m_5Kcrx5nF4oDCh9TTK7WMVOc92KKR6W7LZXnA4L7KpEuNuSuDr9sgVClzM5M73-CMun6srpbIhzBfadg2GmCy9FbR-BVIMmxHjrMfKA-f4pLxGf2PEo_0zbQ-NSkGnUptwPu5SxOxANLNvN_ZHX3fDmStdNIsqNF1qaMx26-IVAmr8SAOxAuOeTkIR2SwlzqE2RyZwIVW-A',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAEuJh-0Yhfaw5oZxV9Yh8YAgxfzGeamiqhwb2oJLbaLzdrGQlEOV9EuERQkmQZSpe_YoUPk95vmiVgPIGHr_aVBnhY49WmoUjya252LtPj07wRTBCdhucJNu3ROkR_qMvmijMlvbOeC9gWu0hWJy5Q2EugY8Cvmc9c4H6sbZUeuYcMsj3YTmgpoizlJ0g_ZkMiCRuH4bJrX2qVMllMtqWZEbna5bwa0ssLNlVYuSJPucWbyIAbSbWLWA',
    ],
  ),
  'truffles': _ProductDetail(
    name: 'Truffles',
    vendor: 'Choco Artisans',
    rating: 4.5,
    reviewCount: 89,
    price: '₦45,000',
    rawPrice: '₦45,000',
    description:
        'An artisanal box of champagne truffles and dark chocolates, handcrafted in small '
        'batches by Lagos finest chocolatiers. Available in milk, dark and white chocolate varieties.',
    location: 'Ikoyi, Lagos',
    sameDay: false,
    imageUrls: [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAzyT65xUrPGO1-flw1shW8JtkPFJ1XsewoCp3gVhMOanU2yxGBisMUWCuZuK3qOFiHiQPcz9K48A0XsQcara57D9HzJP3nJanZhC8FGYC782Sj8wFEW8eW6TyjcBCfF6PWGsHCuQoQ_Y0hbb78vSpAvchZYqt_Q19NeWvd60Wq8tUXZfTlFyGL_S5ej7ih6VT7jtREVPEWC5pZvWZLHjkvF3bD4RNyUAHe5Qq4xtA6byNhdKNnFnrI7A',
    ],
  ),
  'golden-hour': _ProductDetail(
    name: 'Golden Hour',
    vendor: 'GoldCraft NG',
    rating: 4.9,
    reviewCount: 201,
    price: '₦120,000',
    rawPrice: '₦120,000',
    description:
        'A beautifully curated luxury gift set featuring a premium timepiece, hand-stitched '
        'leather wallet, and a sleek fountain pen. Each item is monogram-eligible.',
    location: 'Lekki Phase 1, Lagos',
    sameDay: true,
    imageUrls: [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC2zI6D_Z2ViFCRN_3Nb4XIZRQRMIlO1_tgLP-y85ZHV4itfphT8qE2c7U2QnWwGUtt7wht8R0vGbM1STJZT8s0T76JovqXIuJDE7VzgH4Q3mSn3fPQPmj66fSTSd3X5TD7f4IEoUf8c8GLxdUPaBXPEQf6ztVT8iN4vYQAjDFi8BMBkh6uxTUdpfIuG_TPsuOnkKY5iIJlmvbuR2Si1BLHEgcO97R1THSBgFlFNEyiUa8kxWq6r1LeQQ',
    ],
  ),
  'spa-retreat': _ProductDetail(
    name: 'Spa Retreat',
    vendor: 'Serene Wellness',
    rating: 4.7,
    reviewCount: 56,
    price: '₦65,000',
    rawPrice: '₦65,000',
    description:
        'An elegant spa and wellness gift basket featuring premium skincare products, '
        'scented bath salts, and a luxury loofah. Perfect for self-care lovers.',
    location: 'Abuja (FCT)',
    sameDay: true,
    imageUrls: [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA10NZlqWKpUZ7yF3BQpdK2QTiXj49cZkanWLWSg9mxfn6M27nNi2GI20AOzU0GMkFfVq-652UV6-4tdc0ipBOMEeuewlRl7n5EoFTgv61xFKD1SoeG6LmReKZaHCxXF5Gwt_KbTz8X1rJecn04B5_UAUOZKUI0OZJdFz0Bp7Yh_SMhDOFq3MYK9vDRsWIlLM4PGl-fCmunc9bJw3wnXPD823GoscMYYI8q1ZZOoK4h1bIOk7e93lPxjA',
    ],
  ),
};

_ProductDetail _detailFor(String productId) =>
    _details[productId] ?? _details['eternal-bloom']!;

// ---------------------------------------------------------------------------
// ProductDetailPage
// ---------------------------------------------------------------------------

class ProductDetailPage extends StatefulWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final _ProductDetail _detail;
  late final PageController _pageController;
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _detail = _detailFor(widget.productId);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToImage(int i) {
    setState(() => _currentImage = i);
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final images = _detail.imageUrls;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Scrollable content ───────────────────────────────────────────────
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottom + 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image carousel ─────────────────────────────────────────────
                _ImageCarousel(
                  images: images,
                  currentIndex: _currentImage,
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentImage = i),
                  onClose: () => context.pop(),
                  onPrev: _currentImage > 0
                      ? () => _goToImage(_currentImage - 1)
                      : null,
                  onNext: _currentImage < images.length - 1
                      ? () => _goToImage(_currentImage + 1)
                      : null,
                ),

                // ── Thumbnail strip ────────────────────────────────────────────
                if (images.length > 1)
                  _ThumbnailStrip(
                    images: images,
                    current: _currentImage,
                    onTap: _goToImage,
                  ),

                // ── Detail body ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Verified badge
                      Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            size: 14,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'VERIFIED FORGE VENDOR',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Product name
                      Text(
                        _detail.name,
                        style: AppTextStyles.headlineLg.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Sold by
                      Text(
                        'Sold by ${_detail.vendor}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Color(0xFFFFA500),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_detail.rating}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_detail.reviewCount} reviews',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Price
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                          children: [
                            const TextSpan(
                              text: '₦',
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                            TextSpan(text: _detail.price.replaceFirst('₦', '')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Description
                      Text(
                        _detail.description,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Divider
                      Container(
                        height: 0.5,
                        color: const Color(0x1A000000),
                      ),
                      const SizedBox(height: 14),

                      // Same-day delivery row
                      if (_detail.sameDay)
                        _InfoRow(
                          icon: Icons.local_shipping_outlined,
                          title: 'Same-day available',
                          subtitle: 'Delivers to ${_detail.location}',
                        ),
                      if (_detail.sameDay) const SizedBox(height: 10),

                      // Made especially row
                      _InfoRow(
                        icon: Icons.favorite_border,
                        title: 'Made especially for them',
                        subtitle:
                            'Personalized note & premium gift wrapping included',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky bottom action bar ───────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomBar(price: _detail.price, bottomPad: bottom),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ImageCarousel
// ---------------------------------------------------------------------------

class _ImageCarousel extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onClose;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _ImageCarousel({
    required this.images,
    required this.currentIndex,
    required this.controller,
    required this.onPageChanged,
    required this.onClose,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.45,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // PageView
          PageView.builder(
            controller: controller,
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, i) => CachedNetworkImage(
              imageUrl: images[i],
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: AppColors.surfaceContainerLow),
              errorWidget: (_, __, ___) =>
                  Container(color: AppColors.surfaceContainerLow),
            ),
          ),

          // Counter pill (top center)
          if (images.length > 1)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    '${currentIndex + 1}/${images.length}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Close button (top right)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            right: 12,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),

          // Prev arrow
          if (onPrev != null)
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: onPrev,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Next arrow
          if (onNext != null)
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: onNext,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // View full image (bottom right)
          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.open_in_full, size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    'View full image',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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

// ---------------------------------------------------------------------------
// _ThumbnailStrip
// ---------------------------------------------------------------------------

class _ThumbnailStrip extends StatelessWidget {
  final List<String> images;
  final int current;
  final ValueChanged<int> onTap;

  const _ThumbnailStrip({
    required this.images,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: List.generate(images.length, (i) {
          final active = i == current;
          return Padding(
            padding: EdgeInsets.only(right: i < images.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.outlineVariant,
                    width: active ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: CachedNetworkImage(
                    imageUrl: images[i],
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppColors.surfaceContainerLow),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.surfaceContainerLow),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _InfoRow
// ---------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
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
}

// ---------------------------------------------------------------------------
// _BottomBar
// ---------------------------------------------------------------------------

class _BottomBar extends StatelessWidget {
  final String price;
  final double bottomPad;

  const _BottomBar({required this.price, required this.bottomPad});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 12),
          decoration: const BoxDecoration(
            color: Color(0xF2FFFFFF),
            border: Border(
              top: BorderSide(color: Color(0x14000000), width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                      children: [
                        const TextSpan(
                          text: '₦',
                          style: TextStyle(fontFamily: 'Roboto'),
                        ),
                        TextSpan(text: price.replaceFirst('₦', '')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: const StadiumBorder(),
                      elevation: 3,
                      shadowColor: AppColors.primary.withAlpha(80),
                      textStyle: AppTextStyles.labelMd,
                    ),
                    child: const Text('Add to Moment'),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';

// Secondary palette
const _secondary = Color(0xFF685D4A);
const _secondaryContainer = Color(0xFFEDDEC5);
const _onSecondaryContainer = Color(0xFF6C614E);
const _secondaryFixed = Color(0xFFF0E0C8);
const _onSecondaryFixed = Color(0xFF221B0B);

class SharedWishlistViewPage extends StatefulWidget {
  final String wishlistId;

  const SharedWishlistViewPage({super.key, required this.wishlistId});

  @override
  State<SharedWishlistViewPage> createState() => _SharedWishlistViewPageState();
}

class _SharedWishlistViewPageState extends State<SharedWishlistViewPage> {
  int _cartCount = 0;
  double _cartTotal = 0;
  String _lastAddedName = '';
  int _selectedChipAmount = 5000;
  bool _showToast = false;
  String _toastTitle = '';
  String _toastSubtitle = '';
  Map<String, bool> _addedToCart = {};

  void _addToCart(String name, double amount) {
    setState(() {
      _cartCount++;
      _cartTotal += amount;
      _lastAddedName = name;
      _toastTitle = '$name Added!';
      _toastSubtitle =
          '\u20a6${NumberFormat('#,###').format(amount)} \u00b7 Abuja delivery reserved';
      _showToast = true;
    });
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) setState(() => _showToast = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                'FM',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Shared Gifting',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Shared Wishlist View',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined,
                    color: AppColors.onSurface, size: 26),
                if (_cartCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 160 + bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildOwnerGreetingCard(),
                const SizedBox(height: 24),
                _buildSectionHeader(),
                const SizedBox(height: 16),
                _buildItem1(),
                const SizedBox(height: 16),
                _buildItem2(),
                const SizedBox(height: 16),
                _buildCashItem(),
                const SizedBox(height: 16),
                _buildClaimedItem(),
                const SizedBox(height: 16),
                _buildTrustBanner(),
              ],
            ),
          ),
          _buildToast(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildCartBar(bottomPadding),
          ),
        ],
      ),
    );
  }

  Widget _buildToast() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _showToast ? 80 : -100,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.done, color: AppColors.onPrimary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _toastTitle,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      _toastSubtitle,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
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

  Widget _buildOwnerGreetingCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(13),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Icon(
              Icons.auto_awesome,
              color: _secondary.withAlpha(76),
              size: 48,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryFixed,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCWU5S2yNnmMGVmJNzZNIR6hHMifngTLOreTRq9s2uKmSyncIna3CQd0UYtwoc8LOLas-p_fdUqWPMhyJE_ZtB-oT8FTNCC_P_uHRVEDsz__iZsprauNKWe9prokQ4VhPfpT8LX-L3hLJifyi4sBtDeoy8rarDFm1DkEL5z119CV8P6VBlGMfWSmy_1rm1SHq8kHNZXdB8Wb5shwwRb0V3jKC2H0TWs9caVhm2GgVo5DnBy9eB2Z1AF4Q',
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: AppColors.surfaceContainerHigh,
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.surfaceContainerHigh,
                              child: const Icon(Icons.person,
                                  color: AppColors.onSurfaceVariant),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.celebration,
                              color: AppColors.onPrimary, size: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _secondaryFixed,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: const Text(
                              'Birthday Wishlist',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: ['Montserrat Fallback'],
                                fontSize: 10,
                                color: _onSecondaryFixed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: const Text(
                              '2 of 4 Left',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: ['Montserrat Fallback'],
                                fontSize: 10,
                                color: AppColors.onPrimaryFixed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Sarah's 28th Birthday \u2728",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: ['Montserrat Fallback'],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.calendar_today,
                        color: AppColors.primary, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'October 12, 2025 \u00b7 ',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 12,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      '3 Days Away',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.format_quote,
                            color: AppColors.primary, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "I'd love to celebrate this milestone with the people who matter most. If you're thinking of getting me something, I've put together this little list with things close to my heart.",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: ['Montserrat Fallback'],
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: AppColors.onSurface,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '\u2014 Sarah Afolayan',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: ['Montserrat Fallback'],
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.pin_drop, color: _secondary, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Delivering to Lagos, NG',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: ['Montserrat Fallback'],
                      fontSize: 12,
                      color: _secondary,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.verified_user,
                      color: AppColors.primary, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Private address verified',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: ['Montserrat Fallback'],
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Curated Wishes',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'Tap to send seamlessly...',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Text(
            '4 Gifts',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem1() {
    const id = 'i1';
    final added = _addedToCart[id] == true;
    return _buildProductCard(
      id: id,
      name: 'The Floral Brushstroke Cake',
      vendor: 'Divinebakes',
      price: 24750,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAuXnAU0IgEPgKckxZMYpyFQ2jp7xIfT5SquADAz5A2QusnSj5K1OSSCSdSu5OQnKiSU-2s2SEyQH7j071yjCl_9raqieELwxeG2224juM5jEmofsoR7JCxtnJciteKjLx9SYZx1PHNJitGDEO2SyIkXiblzFBS5K2qSK_stq1h7we1-hSclR81-MWBArXLd-iawdnHP0kMBWOrwqV-BnN5iJeb4ip9eNYJctpHiDrzruO0G1q-SwmAtQ',
      topWish: true,
      added: added,
      onAddToCart: () {
        setState(() => _addedToCart[id] = true);
        _addToCart('The Floral Brushstroke Cake', 24750);
      },
    );
  }

  Widget _buildItem2() {
    const id = 'i2';
    final added = _addedToCart[id] == true;
    return _buildProductCard(
      id: id,
      name: 'Luxury Rose Box \u00b7 50 Velvety Roses',
      vendor: 'Rose Garden \u00b7 Handpicked Long-Stem',
      price: 35000,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC30mtdeOL-xzXks9hcseGIuMqFJF7jfte2mlb01LJx6fKr4aYnd2r90t8pRo7I004BjQd7H9P_BeRBC5aEOIaCNWyubY7JkTrXUI0ZJZR9ETxm0MN-TuVYrABhRdvA9v-SI5-HpkSWTTM2t6jH5xDZ7StShr8ABj9mxfzq4QpHR_K14euqE_yokrLaSGfRJW2HJG2XrAGgowLbuOY71geBqBwVzl2-MlNmFH4aSDzejf2i2os05WtBUQ',
      topWish: false,
      added: added,
      extraInfo: 'Includes personalized gold-foiled greetings card',
      onAddToCart: () {
        setState(() => _addedToCart[id] = true);
        _addToCart('Luxury Rose Box', 35000);
      },
    );
  }

  Widget _buildProductCard({
    required String id,
    required String name,
    required String vendor,
    required double price,
    required String imageUrl,
    required bool topWish,
    required bool added,
    required VoidCallback onAddToCart,
    String? extraInfo,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 192,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 192,
                    color: AppColors.surfaceContainerLow,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 192,
                    color: AppColors.surfaceContainerLow,
                    child: const Icon(Icons.image_not_supported,
                        color: AppColors.onSurfaceVariant, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest.withAlpha(230),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF43A047),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Available',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: ['Montserrat Fallback'],
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (topWish)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _secondaryFixed,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      'Top Wish',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _onSecondaryFixed,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\u20a6${NumberFormat('#,###').format(price)}',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.storefront,
                  size: 13, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                vendor,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (extraInfo != null) ...[
            const SizedBox(height: 6),
            Text(
              extraInfo,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 12,
                color: _secondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: const [
                Icon(Icons.mark_chat_read,
                    color: AppColors.primary, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Pre-fills Sarah's address & note at checkout",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: ['Montserrat Fallback'],
                      fontSize: 12,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: added ? null : onAddToCart,
              icon: Icon(
                added ? Icons.check_circle : Icons.bolt,
                size: 18,
              ),
              label: Text(
                added ? 'Added to Gift Bag' : '1-Tap Add to Cart',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    added ? _secondary : AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                disabledBackgroundColor: _secondary,
                disabledForegroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _secondaryContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.group, size: 13, color: _onSecondaryContainer),
                    SizedBox(width: 4),
                    Text(
                      'Group Gift',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '3 Contributors',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Bespoke Cash Gift Box',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Text(
                '\u20a650,000',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Spa weekend fund \u2014 contribute any amount',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      '\u20a625,000 contributed',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '50% completed',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: const LinearProgressIndicator(
                    value: 0.5,
                    color: AppColors.primary,
                    backgroundColor: AppColors.surfaceContainerHighest,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text(
                      '\u20a625,000 left',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Instant direct payout',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 12,
                        color: _secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [5000, 10000, 15000].map((amount) {
              final selected = _selectedChipAmount == amount;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _selectedChipAmount = amount),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: selected
                            ? _secondary
                            : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '\u20a6${NumberFormat('#,###').format(amount)}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? AppColors.onPrimary
                              : AppColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () =>
                  _addToCart('Cash Gift', _selectedChipAmount.toDouble()),
              icon: const Icon(Icons.payments, size: 18),
              label: Text(
                'Contribute Cash to Cart (\u20a6${NumberFormat('#,###').format(_selectedChipAmount)})',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _secondary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimedItem() {
    return Opacity(
      opacity: 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withAlpha(153),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0, 0, 0, 1, 0,
                    ]),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuA38PUjhhkvML0lO3eU8tp8YK3DvirqNDDr1Kp0H_w0uBdIw5hth29J2u84TLluI3Ahk-3pImls2yj2FOg6gOmXNMrumCqlKa_tFsRQhBEJ_Ukd5Tg7ZyB67j4GpuqaQzumF5qv0pTUTnUg8GcLcXWaFpmkVnwUVgkL1Ovl4V04ufQhf6vlnyPw2_S4he6k9tGk3iFE8U6D3dHEQ2MRH4BNxCGHebxSgk-J2qr2_n2m9qb8pjzm9djltQ',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 180,
                        color: AppColors.surfaceContainerLow,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 180,
                        color: AppColors.surfaceContainerLow,
                        child: const Icon(Icons.image_not_supported,
                            color: AppColors.onSurfaceVariant, size: 40),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh.withAlpha(102),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.check_circle,
                              color: AppColors.primary, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Claimed by Tunde',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: ['Montserrat Fallback'],
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Artisanal White Lilies & Crystal Vase',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: ['Montserrat Fallback'],
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '\u20a635,250',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.done_all,
                    color: AppColors.onSurfaceVariant, size: 14),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Purchased on Oct 8th \u00b7 Will arrive on Sarah's birthday morning",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: ['Montserrat Fallback'],
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.lock, size: 16),
                label: const Text(
                  'Already Claimed',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerHigh,
                  disabledBackgroundColor: AppColors.surfaceContainerHigh,
                  disabledForegroundColor: AppColors.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBanner() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _secondaryContainer,
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Icon(Icons.sentiment_very_satisfied,
                color: _onSecondaryContainer, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No awkward address asking',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Delivery goes directly to the recipient — you never see their private address.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartBar(double bottomPadding) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withAlpha(242),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPadding),
      child: _cartCount == 0
          ? _buildEmptyCartBar()
          : _buildActiveCartBar(),
    );
  }

  Widget _buildEmptyCartBar() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _secondaryFixed,
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Icon(Icons.card_giftcard, color: _onSecondaryFixed, size: 22),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pick any gift to surprise Sarah',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'Scroll up to browse curated items',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_upward, color: AppColors.primary, size: 22),
      ],
    );
  }

  Widget _buildActiveCartBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag,
                  color: AppColors.onPrimary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_cartCount item${_cartCount > 1 ? 's' : ''} in cart',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: ['Montserrat Fallback'],
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  if (_lastAddedName.isNotEmpty)
                    Text(
                      _lastAddedName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\u20a6${NumberFormat('#,###').format(_cartTotal)}',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text(
              'Proceed to Instant Gift Checkout',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.verified, color: _secondary, size: 13),
            SizedBox(width: 4),
            Text(
              'Delivered directly to recipient \u00b7 Handcrafted with love',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 11,
                color: _secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

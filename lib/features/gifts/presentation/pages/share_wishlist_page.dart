import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';

// Secondary palette
const _secondary = Color(0xFF685D4A);
const _secondaryContainer = Color(0xFFEDDEC5);
const _onSecondaryContainer = Color(0xFF6C614E);
const _secondaryFixed = Color(0xFFF0E0C8);
const _onSecondaryFixed = Color(0xFF221B0B);

class ShareWishlistPage extends StatefulWidget {
  final String wishlistId;

  const ShareWishlistPage({super.key, required this.wishlistId});

  @override
  State<ShareWishlistPage> createState() => _ShareWishlistPageState();
}

class _ShareWishlistPageState extends State<ShareWishlistPage>
    with TickerProviderStateMixin {
  bool _qrVisible = false;
  bool _copied = false;
  bool _linkButtonCopied = false;

  late final TextEditingController _noteController;
  late final AnimationController _pingController;
  late final Animation<double> _pingAnimation;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
      text:
          "Hey everyone! My birthday is coming up and I've curated a few things I'd love. No pressure at all — just sharing in case you'd like to make this day extra special. Thank you for being in my life!",
    );
    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _pingAnimation = Tween<double>(begin: 0.8, end: 1.6).animate(
      CurvedAnimation(parent: _pingController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _pingController.dispose();
    super.dispose();
  }

  String get _wishlistUrl => 'forgemoments.com/wishlist/${widget.wishlistId}';

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: 'https://$_wishlistUrl'));
    setState(() {
      _copied = true;
      _linkButtonCopied = true;
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _copied = false);
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _linkButtonCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Share Wishlist',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: ['Montserrat Fallback'],
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSuccessCard(),
                const SizedBox(height: 16),
                _buildSmartGifterCallout(),
                const SizedBox(height: 24),
                _buildDirectShareGrid(),
                const SizedBox(height: 24),
                _buildPersonalNote(),
                const SizedBox(height: 24),
                _buildWishlistPreviewTile(),
                const SizedBox(height: 32),
                _buildSecondaryActions(),
              ],
            ),
          ),
          _buildToast(),
          if (_qrVisible) _buildQrModal(),
        ],
      ),
    );
  }

  Widget _buildToast() {
    return Positioned(
      top: 80,
      left: 24,
      right: 24,
      child: AnimatedOpacity(
        opacity: _copied ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: IgnorePointer(
          ignoring: !_copied,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.inverseSurface,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: AppColors.primaryFixed, size: 18),
                SizedBox(width: 8),
                Text(
                  'Link copied to clipboard!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 14,
                    color: AppColors.inverseOnSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSuccessCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 3)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x40FFD9DE),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x80F0E0C8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Animated badge
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ScaleTransition(
                        scale: _pingAnimation,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _secondaryContainer.withAlpha(80),
                          ),
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: _secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.card_giftcard,
                          color: AppColors.primary,
                          size: 36,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Color(0x14000000), blurRadius: 4),
                            ],
                          ),
                          child: const Icon(Icons.auto_awesome, color: _secondary, size: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'FORGE MOMENTS EXCLUSIVE',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 10,
                    color: _secondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your Wishlist Link is Ready!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Share your curated wishlist with friends and family. They can browse, pick, and gift directly — no awkward conversations needed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lock, color: AppColors.primary, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SelectableText(
                              _wishlistUrl,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: ['Montserrat Fallback'],
                                fontSize: 14,
                                color: AppColors.onSurface,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _secondaryFixed,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: const Text(
                              'Verified',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: ['Montserrat Fallback'],
                                fontSize: 11,
                                color: _onSecondaryFixed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _copyLink,
                          icon: Icon(
                            _linkButtonCopied ? Icons.done : Icons.content_copy,
                            size: 18,
                          ),
                          label: Text(
                            _linkButtonCopied ? 'Copied!' : 'Copy Direct Link',
                            style: const TextStyle(
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartGifterCallout() {
    return Container(
      decoration: BoxDecoration(
        color: _secondaryContainer.withAlpha(153),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Icon(
              Icons.shopping_cart_checkout,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Smart Gifter Integration',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_back_ios_new,
                        size: 12, color: _secondary),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Recipients can checkout in one tap — address, payment, and gift note are all pre-filled from your wishlist.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 12,
                    color: _secondary,
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

  Widget _buildDirectShareGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share Directly',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: ['Montserrat Fallback'],
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildShareCard(
              title: 'WhatsApp',
              subtitle: 'Send to contacts',
              icon: Icons.chat,
              iconBg: const Color(0x1925D366),
              iconColor: const Color(0xFF25D366),
              trailingIcon: Icons.north_east,
              onTap: () {},
            ),
            _buildShareCard(
              title: 'Instagram',
              subtitle: 'Add to story',
              icon: Icons.photo_camera,
              iconBg: AppColors.primaryFixed,
              iconColor: AppColors.primary,
              trailingIcon: Icons.send,
              onTap: () {},
            ),
            _buildShareCard(
              title: 'SMS',
              subtitle: 'Text message',
              icon: Icons.sms,
              iconBg: AppColors.surfaceContainerHigh,
              iconColor: AppColors.onSurface,
              trailingIcon: Icons.north_east,
              onTap: () {},
            ),
            _buildShareCard(
              title: 'QR Code',
              subtitle: 'Scan to view',
              icon: Icons.qr_code_2,
              iconBg: _secondaryFixed,
              iconColor: _secondary,
              trailingIcon: Icons.fullscreen,
              onTap: () => setState(() => _qrVisible = true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShareCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required IconData trailingIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(trailingIcon,
                  size: 16, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Personal Note',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
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
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 16,
                    color: AppColors.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user,
                        color: AppColors.onSurfaceVariant, size: 14),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Address protected — only shared after gift checkout',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: ['Montserrat Fallback'],
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _noteController.text =
                            "Hey everyone! My birthday is coming up and I've curated a few things I'd love. No pressure at all — just sharing in case you'd like to make this day extra special. Thank you for being in my life!";
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: ['Montserrat Fallback'],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWishlistPreviewTile() {
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
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCBd4dCIQaswJFIYFSz7AXXBGp0eR4ZDM6ccD-Oos9QH28LzkJOgYd4eoW5cXgz7eu4oZWKuHd5g94ZZuevNTjdhFlz7X5uuTSgZ1OU_Zzj5q-CcMIuWXiGJRzOH2-BIoIGm9uwKPUObpZMuPwySK119djDDgudiHv7-7VPrjC9pbke3McCm5ZX8oWm9xMIbbW0aN8z6s9YuASMAVaUdZfJnN7SdOp89LjskYSZ2DsS6yhbqMGZcUwamg',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 56,
                height: 56,
                color: AppColors.surfaceContainerLow,
              ),
              errorWidget: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: AppColors.surfaceContainerLow,
                child: const Icon(Icons.image_not_supported,
                    size: 20, color: AppColors.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sarah's 28th Celebration",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '14 Curated Items \u2022 3 Claimed',
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
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: const Row(
              children: [
                Icon(Icons.visibility,
                    size: 14, color: AppColors.onSurface),
                SizedBox(width: 4),
                Text(
                  'Preview',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.preview, size: 18),
            label: const Text(
              'View as Guest / Test Link',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerHigh,
              foregroundColor: AppColors.onSurface,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {},
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: const Text(
            'Done \u2022 Back to Hub',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrModal() {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: _qrVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: () => setState(() => _qrVisible = false),
          child: Container(
            color: Colors.black54,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.qr_code_2,
                              color: AppColors.primary, size: 32),
                          const SizedBox(height: 8),
                          const Text(
                            'Scan Wishlist',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: ['Montserrat Fallback'],
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Have friends scan this code to open your wishlist instantly on their device.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: ['Montserrat Fallback'],
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const CustomPaint(
                              painter: _QrCodePainter(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                _copyLink();
                                setState(() => _qrVisible = false);
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary),
                              child: const Text(
                                'Copy URL Instead',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontFamilyFallback: ['Montserrat Fallback'],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => setState(() => _qrVisible = false),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                size: 16, color: AppColors.onSurface),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QrCodePainter extends CustomPainter {
  const _QrCodePainter();

  static const List<List<int>> _pattern = [
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0],
    [0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rows = _pattern.length;
    final cols = _pattern[0].length;
    final cellW = size.width / cols;
    final cellH = size.height / rows;
    final paint = Paint()..color = const Color(0xFF1A1C1C);

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (_pattern[r][c] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
                c * cellW + 1, r * cellH + 1, cellW - 2, cellH - 2),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

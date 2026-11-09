import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';

// ── Colour constants ──────────────────────────────────────────────────────────
const _kPrimary = Color(0xFFBA0037);
const _kOnPrimary = Color(0xFFFFFFFF);
const _kPrimaryFixed = Color(0xFFFFDADB);
const _kPrimaryFixedDim = Color(0xFFFFB2B7);
const _kOnPrimaryFixed = Color(0xFF40000D);
const _kSurface = Color(0xFFFCF9F8);
const _kSurfaceLowest = Color(0xFFFFFFFF);
const _kSurfaceLow = Color(0xFFF6F3F2);
const _kSurfaceHigh = Color(0xFFEAE7E7);
const _kOnSurface = Color(0xFF1C1B1B);
const _kOnSurfaceVariant = Color(0xFF5B4041);
const _kSecondary = Color(0xFF685D4A);
const _kSecondaryFixed = Color(0xFFF0E0C8);
const _kSecondaryContainer = Color(0xFFEDDEC5);
const _kOnSecondaryFixed = Color(0xFF221B0B);
const _kOnSecondaryContainer = Color(0xFF6C614E);
const _kOutlineVariant = Color(0xFFE4BDBE);
const _kError = Color(0xFFBA1A1A);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _loggingOut = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _loggingOut = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      appBar: AppBar(
        backgroundColor: _kSurface,
        elevation: 0,
        shadowColor: const Color(0x0A000000),
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/logo.png',
                height: 32,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.diamond_outlined, color: _kPrimary),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Account',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: _kOnSurface,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: _kPrimary,
              radius: 16,
              child: const Icon(Icons.person, color: _kOnPrimary, size: 18),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
        children: [
          const SizedBox(height: 16),
          _buildProfileCard(context),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: Text(
              'My Concierge & Account',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _kOnSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
          ),
          _buildMenuCard(context),
          const SizedBox(height: 12),
          _buildSupportCard(context),
          const SizedBox(height: 8),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0FBA0037),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Decorative blurred circle top-right
              Positioned(
                top: -20,
                right: -20,
                child: Opacity(
                  opacity: 0.4,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(
                      width: 144,
                      height: 144,
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          colors: [_kPrimaryFixed, Colors.transparent],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar with verified badge
                  Stack(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_kPrimaryFixed, _kSurfaceLow],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'A',
                            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: _kPrimary,
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
                          decoration: BoxDecoration(
                            color: _kPrimary,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33BA0037),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: _kOnPrimary,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Name / email / phone
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Arinze',
                              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: _kOnSurface,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _kSecondaryFixed,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'FREE',
                                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _kOnSecondaryFixed,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'forgegrouplimited@gmail.com',
                          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _kOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.call,
                              size: 14,
                              color: _kPrimary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '08137512627',
                              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _kOnSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Edit button
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {},
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: _kSurfaceLow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: _kOnSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Moments Club row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _kSurfaceLow.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, size: 18, color: _kPrimary),
                const SizedBox(width: 8),
                Text(
                  'Moments Club Status',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _kOnSurface,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.pushNamed(AppRoutes.nameWallet),
                  child: Row(
                    children: [
                      Text(
                        'Upgrade to Gold',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _kPrimary,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: _kPrimary,
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

  Widget _buildMenuCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _MenuRow(
            icon: Icons.account_balance_wallet,
            iconBg: _kSecondaryFixed,
            iconColor: _kSecondary,
            title: 'Wallet History',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: _kSecondaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '₦250,000.00 available',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _kOnSecondaryContainer,
                ),
              ),
            ),
            onTap: () => context.pushNamed(AppRoutes.nameWallet),
          ),
          const Divider(height: 0, thickness: 0.5, color: _kOutlineVariant),
          _MenuRow(
            icon: Icons.cake,
            iconBg: _kPrimaryFixed,
            iconColor: _kPrimary,
            title: 'Celebrations',
            trailing: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.4, end: 1.0),
              duration: const Duration(milliseconds: 750),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              onEnd: () => setState(() {}),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _kPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            onTap: () => context.pushNamed(AppRoutes.nameCelebrations),
          ),
          const Divider(height: 0, thickness: 0.5, color: _kOutlineVariant),
          _MenuRow(
            icon: Icons.inventory_2_outlined,
            iconBg: _kSurfaceHigh,
            iconColor: _kOnSurfaceVariant,
            title: 'My Orders',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: _kPrimaryFixedDim,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '2 Active Shipments',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _kOnPrimaryFixed,
                ),
              ),
            ),
            onTap: () => context.pushNamed(AppRoutes.nameOrders),
          ),
          const Divider(height: 0, thickness: 0.5, color: _kOutlineVariant),
          _MenuRow(
            icon: Icons.settings_outlined,
            iconBg: _kSurfaceHigh,
            iconColor: _kOnSurfaceVariant,
            title: 'Settings & Preferences',
            trailing: null,
            onTap: () => context.pushNamed(AppRoutes.nameSettings),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: _kSecondaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent,
                  size: 18,
                  color: _kSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Dedicated Support',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _kOnSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _kSecondaryFixed.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '24/7 Available',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _kOnSecondaryFixed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Need personal assistance curating a moment? Our dedicated gifting liaison is here to help.',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _kOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _SupportRow(
            icon: Icons.phone_in_talk,
            text: '08137512627',
            onTap: () async {
              final uri = Uri.parse('tel:08137512627');
              // ignore: deprecated_member_use
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
          ),
          const SizedBox(height: 8),
          _SupportRow(
            icon: Icons.mail_outlined,
            text: 'forgegrouplimited@gmail.com',
            onTap: () async {
              final uri = Uri.parse(
                'mailto:forgegrouplimited@gmail.com',
              );
              // ignore: deprecated_member_use
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Column(
      children: [
        const SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _kSurfaceLow,
            foregroundColor: _kError,
            elevation: 0,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Colors.transparent,
          ),
          onPressed: _loggingOut ? null : _handleLogout,
          child: _loggingOut
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _kError,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ── Private helpers ───────────────────────────────────────────────────────────

// Minimal stubs so the file compiles without url_launcher import conflict.
// In production, add url_launcher to pubspec and use the real package.
Future<bool> canLaunchUrl(Uri uri) async => false;
Future<bool> launchUrl(Uri uri) async => false;

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _kOnSurface,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ] else ...[
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: _kOnSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _SupportRow({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _kSurfaceLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: _kPrimary),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _kPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

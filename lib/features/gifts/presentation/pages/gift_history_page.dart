import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/wishlist.dart';
import '../blocs/wishlist_cubit.dart';

// ---------------------------------------------------------------------------
// Design-system palette for the warm secondary tones used in this screen.
// These are intentionally separate from AppColors (which uses amber secondary).
// ---------------------------------------------------------------------------
const _secondary = Color(0xFF685D4A);
const _secondaryContainer = Color(0xFFEDDEC5);
const _onSecondaryContainer = Color(0xFF6C614E);
const _secondaryFixed = Color(0xFFF0E0C8);
const _onSecondaryFixed = Color(0xFF221B0B);

// ---------------------------------------------------------------------------
// Currency formatter
// ---------------------------------------------------------------------------
final _fmt = NumberFormat.currency(
  locale: 'en_NG',
  symbol: '₦',
  decimalDigits: 0,
);

String _fmtDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('MMM d, yyyy').format(date);
}

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class GiftHistoryPage extends StatefulWidget {
  const GiftHistoryPage({super.key});

  @override
  State<GiftHistoryPage> createState() => _GiftHistoryPageState();
}

class _GiftHistoryPageState extends State<GiftHistoryPage> {
  late final WishlistCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = WishlistCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.load();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const _WishlistHubBody(),
    );
  }
}

class _WishlistHubBody extends StatelessWidget {
  const _WishlistHubBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.surface,
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomScrollView(
                slivers: [
                  // ── A. Sub-header ─────────────────────────────────────────
                  SliverToBoxAdapter(child: _SubHeader()),

                  // ── B. Ambient luxury banner ───────────────────────────────
                  const SliverToBoxAdapter(child: _LuxuryBanner()),

                  // ── C. Filter pills ────────────────────────────────────────
                  const SliverToBoxAdapter(child: _FilterPills()),

                  // ── D. Wishlist cards ─────────────────────────────────────
                  const SliverToBoxAdapter(child: _WishlistCards()),

                  // ── E. Tip section ────────────────────────────────────────
                  const SliverToBoxAdapter(child: _TipSection()),

                  // ── F. Bottom padding ─────────────────────────────────────
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.paddingOf(context).bottom + 160,
                    ),
                  ),
                ],
              ),

              // ── FAB — sits directly above the nav bar ───────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.paddingOf(context).bottom,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(18),
                        blurRadius: 12,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: _BottomFab(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// A. Sub-header
// ---------------------------------------------------------------------------

class _SubHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, top + 16, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'REGISTRY & CURATIONS',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'My Wishlists',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Right: New Wishlist pill button
          ElevatedButton.icon(
            onPressed: () =>
                context.pushNamed(AppRoutes.nameCreateWishlist),
            icon: const Icon(Icons.add_circle, size: 16),
            label: const Text(
              '+ New Wishlist',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _secondaryContainer,
              foregroundColor: _onSecondaryContainer,
              elevation: 0,
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// B. Ambient luxury banner
// ---------------------------------------------------------------------------

class _LuxuryBanner extends StatelessWidget {
  const _LuxuryBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.primaryFixed,
              AppColors.surfaceContainer,
              _secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Decorative circle blob
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.07),
                ),
              ),
            ),

            // Content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome,
                                size: 12, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text(
                              'Curate Your Desires',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: ['Montserrat Fallback'],
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Build your perfect wishlist and share it with loved ones who want to make your moments unforgettable.',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: ['Montserrat Fallback'],
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// C. Filter pills
// ---------------------------------------------------------------------------

const _filters = [
  _FilterDef(key: 'all', label: 'All Wishlists (3)'),
  _FilterDef(key: 'birthday', label: 'Birthdays (1)'),
  _FilterDef(key: 'milestone', label: 'Milestones (1)'),
  _FilterDef(key: 'secret', label: 'Secret Desires (1)'),
];

class _FilterDef {
  final String key;
  final String label;
  const _FilterDef({required this.key, required this.label});
}

class _FilterPills extends StatelessWidget {
  const _FilterPills();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                ..._filters.map((f) {
                  final isActive = state.activeFilter == f.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () =>
                          context.read<WishlistCubit>().setFilter(f.key),
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          f.label,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? AppColors.onPrimary
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 12), // right padding equivalent
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// D. Wishlist cards
// ---------------------------------------------------------------------------

class _WishlistCards extends StatelessWidget {
  const _WishlistCards();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        final list = state.filtered;
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Center(
              child: Text(
                'No wishlists found.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            children: list
                .map((w) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _WishlistCard(wishlist: w),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final Wishlist wishlist;
  const _WishlistCard({required this.wishlist});

  @override
  Widget build(BuildContext context) {
    final productItems = wishlist.items
        .where((i) => i.type == WishlistItemType.product)
        .toList();
    final cashItems = wishlist.items
        .where((i) => i.type == WishlistItemType.cash)
        .toList();
    final hasCashOnly = productItems.isEmpty && cashItems.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header row
          _CardHeader(wishlist: wishlist),
          const SizedBox(height: 12),

          // Items display
          if (hasCashOnly)
            _CashContributorSection(item: cashItems.first)
          else if (wishlist.id == 'w1')
            _ProductGridSection(items: productItems)
          else
            _ProductListSection(items: productItems),

          // Funding progress (only for product wishlists)
          if (!hasCashOnly) _FundingProgress(wishlist: wishlist),

          const SizedBox(height: 12),

          // Action buttons
          _ActionButtons(wishlist: wishlist, hasCashOnly: hasCashOnly),
        ],
      ),
    );
  }
}

// Card header row
class _CardHeader extends StatelessWidget {
  final Wishlist wishlist;
  const _CardHeader({required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Occasion badge + date
              Row(
                children: [
                  _OccasionBadge(occasion: wishlist.occasion),
                  if (wishlist.targetDate != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      _fmtDate(wishlist.targetDate),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),

              // Title
              Text(
                wishlist.title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),

              // Items count + total
              Text(
                '${wishlist.items.length} item${wishlist.items.length == 1 ? '' : 's'} · Total: ${_fmt.format(wishlist.totalValue)}',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _secondary,
                ),
              ),
            ],
          ),
        ),

        // More vert button
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.more_vert,
              size: 20, color: AppColors.onSurface),
        ),
      ],
    );
  }
}

// Occasion badge pill
class _OccasionBadge extends StatelessWidget {
  final WishlistOccasion occasion;
  const _OccasionBadge({required this.occasion});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (occasion) {
      case WishlistOccasion.birthday:
        bg = AppColors.primaryFixed;
        fg = AppColors.onPrimaryFixed;
        icon = Icons.cake;
        label = 'Birthday';
        break;
      case WishlistOccasion.anniversary:
      case WishlistOccasion.milestone:
        bg = _secondaryFixed;
        fg = _onSecondaryFixed;
        icon = Icons.favorite;
        label = occasion == WishlistOccasion.anniversary
            ? 'Anniversary'
            : 'Milestone';
        break;
      case WishlistOccasion.secret:
        bg = _secondaryContainer;
        fg = _onSecondaryContainer;
        icon = Icons.payments;
        label = 'Secret';
        break;
      default:
        bg = AppColors.surfaceContainerHigh;
        fg = AppColors.onSurface;
        icon = Icons.auto_awesome;
        label = occasion.name;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// 4-column grid thumbnails (birthday wishlist)
class _ProductGridSection extends StatelessWidget {
  final List<WishlistItem> items;
  const _ProductGridSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 90,
      ),
      itemCount: items.length,
      itemBuilder: (_, idx) {
        final item = items[idx];
        return _GridThumbnail(item: item);
      },
    );
  }
}

class _GridThumbnail extends StatelessWidget {
  final WishlistItem item;
  const _GridThumbnail({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (_, __) => Container(
                          color: AppColors.surfaceContainerHigh,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surfaceContainerHigh,
                          child: const Icon(Icons.image_not_supported,
                              size: 16, color: AppColors.onSurfaceVariant),
                        ),
                      )
                    : Container(
                        color: AppColors.surfaceContainerHigh,
                        child: const Icon(Icons.image,
                            size: 16, color: AppColors.onSurfaceVariant),
                      ),
              ),

              // Claimed overlay
              if (item.claimed)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        size: 12, color: AppColors.onPrimary),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: ['Montserrat Fallback'],
            fontSize: 10,
            color: AppColors.onSurface,
          ),
        ),
        Text(
          _fmt.format(item.price),
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: item.claimed
                ? AppColors.onSurfaceVariant
                : AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// Vertical list of item rows (anniversary wishlist)
class _ProductListSection extends StatelessWidget {
  final List<WishlistItem> items;
  const _ProductListSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ProductListRow(item: item),
              ))
          .toList(),
    );
  }
}

class _ProductListRow extends StatelessWidget {
  final WishlistItem item;
  const _ProductListRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 48,
            height: 48,
            child: item.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.surfaceContainerHigh,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(Icons.image_not_supported,
                          size: 16, color: AppColors.onSurfaceVariant),
                    ),
                  )
                : Container(
                    color: AppColors.surfaceContainerHigh,
                    child: const Icon(Icons.image,
                        size: 16, color: AppColors.onSurfaceVariant),
                  ),
          ),
        ),
        const SizedBox(width: 12),

        // Name + awaiting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Awaiting gifter',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Price
        Text(
          _fmt.format(item.price),
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: ['Montserrat Fallback'],
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// Cash contributor pulse section (secret wishlist)
class _CashContributorSection extends StatelessWidget {
  final WishlistItem item;
  const _CashContributorSection({required this.item});

  @override
  Widget build(BuildContext context) {
    final target = item.targetAmount ?? item.price;
    final contributed = item.contributedAmount ?? 0;
    final remaining = target - contributed;
    final progress = target > 0 ? (contributed / target).clamp(0.0, 1.0) : 0.0;
    final count = item.contributorCount ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contributors + amounts row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Contributed by $count friend${count == 1 ? '' : 's'}',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _fmt.format(contributed),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: ['Montserrat Fallback'],
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' / ${_fmt.format(target)}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: ['Montserrat Fallback'],
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            color: AppColors.primary,
            backgroundColor: AppColors.surfaceContainerHigh,
          ),
        ),
        const SizedBox(height: 12),

        // Avatar row + remaining
        Row(
          children: [
            // Avatar circles
            _AvatarCircle(label: 'AO', bg: AppColors.primaryFixed),
            const SizedBox(width: 4),
            _AvatarCircle(label: 'TA', bg: _secondaryFixed),
            const SizedBox(width: 4),
            _AvatarCircle(
                label: 'FM', bg: const Color(0xFFE2E2E4)),
            const SizedBox(width: 10),
            Text(
              '${_fmt.format(remaining)} remaining',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String label;
  final Color bg;
  const _AvatarCircle({required this.label, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surfaceContainerLowest, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: ['Montserrat Fallback'],
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}

// Funding progress bar
class _FundingProgress extends StatelessWidget {
  final Wishlist wishlist;
  const _FundingProgress({required this.wishlist});

  @override
  Widget build(BuildContext context) {
    final percent = (wishlist.fundedPercent * 100).round();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${wishlist.claimedCount} of ${wishlist.items.length} gift${wishlist.items.length == 1 ? '' : 's'} claimed',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '$percent% funded',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: wishlist.fundedPercent,
              minHeight: 6,
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceContainerHigh,
            ),
          ),
        ],
      );
  }
}

// Action buttons row
class _ActionButtons extends StatelessWidget {
  final Wishlist wishlist;
  final bool hasCashOnly;
  const _ActionButtons({required this.wishlist, required this.hasCashOnly});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Share Link
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share, size: 16),
            label: const Text(
              'Share Link',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              elevation: 0,
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Manage Items / View Contributors
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(
              hasCashOnly ? Icons.group : Icons.edit_note,
              size: 16,
            ),
            label: Text(
              hasCashOnly ? 'View Contributors' : 'Manage Items',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurface,
              side: const BorderSide(color: AppColors.outlineVariant),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// E. Tip section
// ---------------------------------------------------------------------------

class _TipSection extends StatelessWidget {
  const _TipSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heart icon circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),

          // Text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add gifts seamlessly as you explore',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'While browsing the store, tap the heart icon on any product to add it directly to one of your wishlists.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
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
// Bottom FAB
// ---------------------------------------------------------------------------

class _BottomFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () =>
            context.pushNamed(AppRoutes.nameCreateWishlist),
        icon: const Icon(Icons.add_circle, size: 20),
        label: const Text(
          'Create New Wishlist',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: ['Montserrat Fallback'],
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}

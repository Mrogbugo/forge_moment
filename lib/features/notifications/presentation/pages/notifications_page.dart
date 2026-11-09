import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../blocs/notifications_cubit.dart';

// ---------------------------------------------------------------------------
// Notification data model
// ---------------------------------------------------------------------------

enum _NotifType { gifted, claimed }

class _Notif {
  final _NotifType type;
  final String title;
  final String body;
  final String? claimLink;
  final String date;
  final bool unread;

  const _Notif({
    required this.type,
    required this.title,
    required this.body,
    this.claimLink,
    required this.date,
    this.unread = false,
  });
}

const _notifications = [
  _Notif(
    type: _NotifType.claimed,
    title: 'Your gift was claimed!',
    body: 'Arinze claimed your gift.',
    date: '9 Sept',
    unread: true,
  ),
  _Notif(
    type: _NotifType.gifted,
    title: 'Gift Sent!',
    body: 'Your gift to Benjamin is ready. Share this claim link:',
    claimLink: 'https://www.forgemoments.com/gift/07sr...',
    date: '8 Sept',
    unread: true,
  ),
  _Notif(
    type: _NotifType.gifted,
    title: 'Gift Sent!',
    body: 'Your gift to Chisom is ready. Share this claim link:',
    claimLink: 'https://www.forgemoments.com/gift/fAwc...',
    date: '8 Sept',
    unread: true,
  ),
  _Notif(
    type: _NotifType.claimed,
    title: 'Your gift was claimed!',
    body: 'Patrickobafemi claimed your gift.',
    date: '1 Sept',
  ),
  _Notif(
    type: _NotifType.gifted,
    title: 'Gift Sent!',
    body: 'Your gift to Rico is ready. Share this claim link:',
    claimLink: 'https://www.forgemoments.com/gift/wBFH...',
    date: '1 Sept',
  ),
];

// ---------------------------------------------------------------------------
// NotificationsPage
// ---------------------------------------------------------------------------

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final List<_Notif> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(_notifications);
  }

  void _markAllRead() {
    setState(() {
      // Replace each item with an identical copy where unread = false
      for (var i = 0; i < _items.length; i++) {
        final n = _items[i];
        _items[i] = _Notif(
          type: n.type,
          title: n.title,
          body: n.body,
          claimLink: n.claimLink,
          date: n.date,
          unread: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(
          repository: GetIt.instance<NotificationsRepository>()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Notifications',
                      style: AppTextStyles.headlineMd.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Spacer(),
                    // Mark all as read
                    GestureDetector(
                      onTap: _markAllRead,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                              color: AppColors.outlineVariant),
                        ),
                        child: Text(
                          'Mark all as read',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── List ───────────────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (_, i) =>
                      _NotifCard(notif: _items[i]),
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
// _NotifCard
// ---------------------------------------------------------------------------

class _NotifCard extends StatelessWidget {
  final _Notif notif;
  const _NotifCard({required this.notif});

  @override
  Widget build(BuildContext context) {
    final isClaimed = notif.type == _NotifType.claimed;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon ───────────────────────────────────────────────────────
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isClaimed
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFF1F3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isClaimed
                  ? Icons.check_circle_outline_rounded
                  : Icons.card_giftcard_rounded,
              size: 22,
              color: isClaimed
                  ? const Color(0xFF2E7D32)
                  : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),

          // ── Content ────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  notif.title,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),

                // Body text
                Text(
                  notif.body,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),

                // Claim link (for Gift Sent)
                if (notif.claimLink != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    notif.claimLink!,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Action buttons
                  Row(
                    children: [
                      // Open gift link
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            'Open gift link',
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
                      const SizedBox(width: 8),
                      // Copy link
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: notif.claimLink!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Link copied!'),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(
                                color: AppColors.outlineVariant),
                          ),
                          child: Text(
                            'Copy link',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 6),

                // Date
                Text(
                  notif.date,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant.withAlpha(160),
                  ),
                ),
              ],
            ),
          ),

          // ── Unread dot ─────────────────────────────────────────────────
          if (notif.unread) ...[
            const SizedBox(width: 8),
            Container(
              width: 9,
              height: 9,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

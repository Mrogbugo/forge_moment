import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';

// ── Colour constants ──────────────────────────────────────────────────────────
const _kPrimary = Color(0xFFBA0037);
const _kOnPrimary = Color(0xFFFFFFFF);
const _kPrimaryFixed = Color(0xFFFFDADB);
const _kSurface = Color(0xFFFCF9F8);
const _kSurfaceLowest = Color(0xFFFFFFFF);
const _kSurfaceLow = Color(0xFFF6F3F2);
const _kSurfaceContainer = Color(0xFFF0EDED);
const _kOnSurface = Color(0xFF1C1B1B);
const _kOnSurfaceVariant = Color(0xFF5B4041);
const _kSecondary = Color(0xFF685D4A);
const _kSecondaryFixed = Color(0xFFF0E0C8);
const _kSecondaryContainer = Color(0xFFEDDEC5);
const _kOutlineVariant = Color(0xFFE4BDBE);

class CelebrationsListPage extends StatefulWidget {
  const CelebrationsListPage({super.key});

  @override
  State<CelebrationsListPage> createState() => _CelebrationsListPageState();
}

class _CelebrationsListPageState extends State<CelebrationsListPage> {
  int _tab = 0;
  bool _remindersOn = true;
  bool _autoSuggestOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      appBar: AppBar(
        backgroundColor: _kSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _kOnSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Celebrations',
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _kOnSurface,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: _kPrimaryFixed,
                borderRadius: BorderRadius.circular(999),
              ),
              child: TextButton.icon(
                onPressed: () =>
                    context.pushNamed(AppRoutes.nameAddCelebration),
                icon: const Icon(Icons.add, size: 16, color: _kPrimary),
                label: Text(
                  'Add Celebration',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kPrimary,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back breadcrumb
            TextButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.chevron_left, size: 18),
              label: Text(
                'Back to Account',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: _kOnSurfaceVariant,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 8),
            // Intro banner
            _buildIntroBanner(),
            const SizedBox(height: 16),
            // Segmented tabs
            _buildTabs(),
            const SizedBox(height: 16),
            // Content
            if (_tab == 0) ...[
              _CelebrationCard(
                icon: Icons.cake,
                iconBg: _kPrimaryFixed,
                iconColor: _kPrimary,
                title: "Sarah's Birthday",
                badge: 'Sister',
                subtitle: null,
                dateText: 'Oct 12 (In 3 days)',
                dateColor: _kPrimary,
                note: '"A luxury getaway is on her wishlist"',
                bottomWidget: _buildCurateRow(
                  alertText: 'Alert sent today',
                  buttonLabel: 'Curate Moment',
                  buttonIcon: Icons.arrow_forward,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 12),
              _CelebrationCard(
                icon: Icons.favorite,
                iconBg: _kSecondaryFixed,
                iconColor: _kSecondary,
                title: 'Wedding Anniversary',
                badge: 'Friends · 5 Years Milestone',
                subtitle: 'James & Maria',
                dateText: 'Oct 15 (In 6 days)',
                dateColor: _kPrimary,
                note: '"Prefers champagne & artisanal hampers"',
                bottomWidget: _buildCurateRow(
                  alertText: null,
                  buttonLabel: 'Send Gift',
                  buttonIcon: Icons.featured_play_list,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 12),
              _CelebrationCard(
                icon: Icons.cake,
                iconBg: _kPrimaryFixed,
                iconColor: _kPrimary,
                title: "Mum's Birthday",
                badge: 'Family',
                subtitle: null,
                dateText: 'Nov 02',
                dateColor: _kOnSurfaceVariant,
                note: '"Loves fresh white lilies and custom jewelry"',
                bottomWidget: _buildCurateRow(
                  alertText: null,
                  buttonLabel: 'Plan Surprise',
                  buttonIcon: Icons.arrow_forward,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 12),
              _CelebrationCard(
                icon: Icons.workspace_premium,
                iconBg: _kSecondaryFixed,
                iconColor: _kSecondary,
                title: "David's Promotion",
                badge: 'Colleague',
                subtitle: null,
                dateText: 'Nov 18',
                dateColor: _kOnSurfaceVariant,
                note: '"Airtime or curated designer gift set"',
                bottomWidget: _buildCurateRow(
                  alertText: null,
                  buttonLabel: 'Plan Surprise',
                  buttonIcon: Icons.arrow_forward,
                  onPressed: () {},
                ),
              ),
            ] else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      Icon(
                        _tab == 1 ? Icons.history : Icons.calendar_month,
                        size: 48,
                        color: _kOutlineVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _tab == 1 ? 'No past celebrations yet' : 'Calendar view coming soon',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 14,
                          color: _kOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            _buildAutomationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroBanner() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_kPrimaryFixed, _kSurfaceLow, _kSecondaryContainer],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: _kPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'GENTLE REMINDERS',
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _kOnSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Never Miss a Moment',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: _kOnSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Set up smart reminders for every special occasion and let Forge AI curate the perfect gift.',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _kOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Opacity(
            opacity: 0.08,
            child: Icon(
              Icons.celebration,
              size: 120,
              color: _kPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    final tabs = ['Upcoming (4)', 'Past', 'Calendar'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _kSurfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = _tab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? _kSurfaceLowest : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isActive
                      ? [
                          const BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tabs[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? _kPrimary : _kOnSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurateRow({
    required String? alertText,
    required String buttonLabel,
    required IconData buttonIcon,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        if (alertText != null) ...[
          const Icon(Icons.notifications_active, size: 16, color: _kSecondary),
          const SizedBox(width: 4),
          Text(
            alertText,
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _kOnSurfaceVariant,
            ),
          ),
        ],
        const Spacer(),
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(buttonIcon, size: 14),
          label: Text(
            buttonLabel,
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _kPrimary,
            foregroundColor: _kOnPrimary,
            minimumSize: const Size(0, 36),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildAutomationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kSurfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune, color: _kPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Automation & Reminder Preferences',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _kOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ToggleRow(
            title: 'Smart Celebration Reminders',
            subtitle: 'Push notifications active 7 days in advance',
            value: _remindersOn,
            onChanged: (v) => setState(() => _remindersOn = v),
          ),
          const SizedBox(height: 8),
          _ToggleRow(
            title: 'Auto-suggest Forge AI Curations',
            subtitle: 'Generate bespoke gift proposals automatically',
            value: _autoSuggestOn,
            onChanged: (v) => setState(() => _autoSuggestOn = v),
          ),
        ],
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

class _CelebrationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String badge;
  final String? subtitle;
  final String dateText;
  final Color dateColor;
  final String note;
  final Widget bottomWidget;

  const _CelebrationCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.dateText,
    required this.dateColor,
    required this.note,
    required this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _kOnSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _kSurfaceContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _kOnSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: _kOnSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      dateText,
                      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: dateColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  size: 18,
                  color: _kOnSurfaceVariant,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _kSurfaceLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.format_quote, size: 14, color: _kOnSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    note,
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: _kOnSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          bottomWidget,
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _kOnSurface,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: _kOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: _kPrimary,
          activeTrackColor: _kPrimary.withValues(alpha: 0.5),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

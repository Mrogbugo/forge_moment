import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

// ---------------------------------------------------------------------------
// Template data
// ---------------------------------------------------------------------------

enum _Badge { free, premium }

class _Template {
  final String emoji;
  final String tag;
  final Color tagColor;
  final Color bgFrom;
  final Color bgTo;
  final String title;
  final _Badge badge;
  final String description;
  final String meta;
  final String? route; // null = coming soon

  const _Template({
    required this.emoji,
    required this.tag,
    required this.tagColor,
    required this.bgFrom,
    required this.bgTo,
    required this.title,
    required this.badge,
    required this.description,
    required this.meta,
    this.route,
  });
}

const _templates = [
  _Template(
    emoji: '💵',
    tag: 'CASH',
    tagColor: AppColors.primary,
    bgFrom: Color(0xFFFFF1F3),
    bgTo: Color(0xFFFFD9DE),
    title: 'Cash Reveal Box',
    badge: _Badge.free,
    description: 'Curated ribbon cash presentation with custom personal notes.',
    meta: 'Instant Transfer • NGN',
    route: AppRoutes.createMoneyPackage,
  ),
  _Template(
    emoji: '📲',
    tag: 'AIRTIME',
    tagColor: Color(0xFFB45309),
    bgFrom: Color(0xFFFFFBEB),
    bgTo: Color(0xFFFED7AA),
    title: 'Airtime Surprise',
    badge: _Badge.free,
    description: 'Send multi-network recharge surprise instantly across all carriers.',
    meta: 'Instant Top-Up • MTN, Airtel, Glo',
    route: AppRoutes.createAirtime,
  ),
  _Template(
    emoji: '🎁',
    tag: 'VIP',
    tagColor: Color(0xFFBE185D),
    bgFrom: Color(0xFFFCE7F3),
    bgTo: Color(0xFFFECDD3),
    title: 'Keepsake Hamper',
    badge: _Badge.premium,
    description: 'Custom audio message & multimedia reveal in a rose gold box.',
    meta: 'Voice note • Photo reel • Confetti',
    route: null,
  ),
  _Template(
    emoji: '🎟️',
    tag: 'EXPERIENCE',
    tagColor: Color(0xFF4F46E5),
    bgFrom: Color(0xFFEEF2FF),
    bgTo: Color(0xFFE9D5FF),
    title: 'Digital Voucher Box',
    badge: _Badge.premium,
    description: 'Spa days, dining, and shopping vouchers with animated reveal.',
    meta: 'Redeemable anywhere • Instant code',
    route: null,
  ),
];

// ---------------------------------------------------------------------------
// Filter tabs
// ---------------------------------------------------------------------------

enum _Filter { all, free, premium }

// ---------------------------------------------------------------------------
// DigitalGiftTemplatePage
// ---------------------------------------------------------------------------

class DigitalGiftTemplatePage extends StatefulWidget {
  const DigitalGiftTemplatePage({super.key});

  @override
  State<DigitalGiftTemplatePage> createState() => _DigitalGiftTemplatePageState();
}

class _DigitalGiftTemplatePageState extends State<DigitalGiftTemplatePage> {
  int? _selected = 0; // Cash Reveal Box pre-selected
  _Filter _filter = _Filter.all;

  List<_Template> get _visible {
    return switch (_filter) {
      _Filter.free => _templates.where((t) => t.badge == _Badge.free).toList(),
      _Filter.premium => _templates.where((t) => t.badge == _Badge.premium).toList(),
      _Filter.all => _templates,
    };
  }

  void _onTap(int index) {
    final tpl = _visible[index];
    if (tpl.route == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coming soon — stay tuned!')),
      );
      return;
    }
    setState(() => _selected = index);
    context.push(tpl.route!);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final visible = _visible;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _TopBar(onBack: () => context.pop()),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 20, 16, bottom + 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subtitle
                  Center(
                    child: Text(
                      'Choose an interactive reveal template\nto delight your recipient',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Filter pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterPill(
                          label: 'All',
                          active: _filter == _Filter.all,
                          onTap: () => setState(() => _filter = _Filter.all),
                        ),
                        const SizedBox(width: 8),
                        _FilterPill(
                          label: 'Free',
                          active: _filter == _Filter.free,
                          onTap: () => setState(() => _filter = _Filter.free),
                        ),
                        const SizedBox(width: 8),
                        _FilterPill(
                          label: 'Premium',
                          active: _filter == _Filter.premium,
                          onTap: () => setState(() => _filter = _Filter.premium),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Template cards
                  ...List.generate(visible.length, (i) {
                    final isSelected = _selected == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TemplateCard(
                        template: visible[i],
                        selected: isSelected,
                        onTap: () => _onTap(i),
                      ),
                    );
                  }),
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
// _TopBar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  const _TopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      padding: EdgeInsets.fromLTRB(8, top + 4, 16, 0),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: Color(0x1ABA0037), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                color: AppColors.onSurfaceVariant,
              ),
              Expanded(
                child: Text(
                  'Select a Template',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Spacer to balance the back button
              const SizedBox(width: 40),
            ],
          ),
          // Progress bar (50%)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: 0.5,
                backgroundColor: AppColors.surfaceVariant,
                color: AppColors.primary,
                minHeight: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FilterPill
// ---------------------------------------------------------------------------

class _FilterPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TemplateCard
// ---------------------------------------------------------------------------

class _TemplateCard extends StatelessWidget {
  final _Template template;
  final bool selected;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = template.badge == _Badge.premium;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.primary.withAlpha(25)
                  : Colors.black.withAlpha(10),
              blurRadius: selected ? 20 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji thumbnail
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [template.bgFrom, template.bgTo],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(template.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 2),
                  Text(
                    template.tag,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: template.tagColor,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          template.title,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _Badge2(premium: isPremium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.description,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (selected)
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 13, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Selected & Ready',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      template.meta,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onSurfaceVariant.withAlpha(160),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Selection indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.outlineVariant,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 13, color: AppColors.onPrimary)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _Badge2 — FREE (green) / PREMIUM (amber) label
// ---------------------------------------------------------------------------

class _Badge2 extends StatelessWidget {
  final bool premium;
  const _Badge2({required this.premium});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: premium ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        premium ? 'PREMIUM' : 'FREE',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

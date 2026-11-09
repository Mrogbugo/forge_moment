import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

// ---------------------------------------------------------------------------
// Static data
// ---------------------------------------------------------------------------

const _sortOptions = [
  'Recommended',
  'Most Popular',
  'Newest Gifts',
  'Price: Low to High',
  'Price: High to Low',
  'Highest Rated',
];

const _categories = [
  'All Gifts',
  'Flowers & Bouquets',
  'Luxury Hampers',
  'Fine Jewelry',
  'Perfumes & Scents',
  'Artisanal Treats',
  'Digital Gift Cards',
];

const _pricePresets = [
  ('Under ₦25,000', 0.0, 25000.0),
  ('₦25,000 – ₦75,000', 25000.0, 75000.0),
  ('₦75,000 – ₦150,000', 75000.0, 150000.0),
  ('₦150,000+', 150000.0, 200000.0),
];

const _neighborhoods = [
  'Lagos',
  'Enugu',
  'Ebonyi',
  'Abuja (Central)',
];

const _occasions = [
  ('Romantic', '💕'),
  ('Birthday', '🎂'),
  ('Anniversary', '💍'),
  ('Just Because', '🌟'),
  ('Get Well', '🌺'),
  ('Congratulations', '🎉'),
];

// ---------------------------------------------------------------------------
// FilterPage
// ---------------------------------------------------------------------------

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // ── State ──────────────────────────────────────────────────────────────────
  String _sortBy = 'Recommended';
  final Set<String> _selectedCategories = {'Flowers & Bouquets'};
  RangeValues _priceRange = const RangeValues(25000, 75000);
  String? _selectedPricePreset = '₦25,000 – ₦75,000';
  final Set<String> _selectedNeighborhoods = {'Lagos'};
  bool _sameDayEnabled = true;
  bool _instantEnabled = false;
  String? _selectedOccasion = 'Romantic';

  void _clearAll() {
    setState(() {
      _sortBy = 'Recommended';
      _selectedCategories.clear();
      _priceRange = const RangeValues(0, 200000);
      _selectedPricePreset = null;
      _selectedNeighborhoods.clear();
      _sameDayEnabled = false;
      _instantEnabled = false;
      _selectedOccasion = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Scrollable content ─────────────────────────────────────────────
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(
                child: _buildSection(
                  'Sort By',
                  Icons.sort,
                  _buildSortBy(),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSection(
                  'Category',
                  Icons.redeem_outlined,
                  _buildCategories(),
                  trailingLabel: _selectedCategories.isEmpty
                      ? null
                      : '${_selectedCategories.length} Selected',
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSection(
                  'Price Range',
                  Icons.payments_outlined,
                  _buildPriceRange(context),
                  actionLabel: 'Reset',
                  onAction: () => setState(() {
                    _priceRange = const RangeValues(0, 200000);
                    _selectedPricePreset = null;
                  }),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSection(
                  'Location & Delivery Zone',
                  Icons.near_me_outlined,
                  _buildLocationDelivery(),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSection(
                  'Occasion & Sentiment',
                  Icons.favorite_border,
                  _buildOccasions(),
                ),
              ),
              // Space for sticky bottom bar
              SliverToBoxAdapter(child: SizedBox(height: bottomPad + 120)),
            ],
          ),

          // ── Sticky bottom action bar ───────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBar(context, bottomPad),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(20, topPad + 12, 20, 16),
      child: Row(
        children: [
          _CircleButton(
            onTap: () => context.pop(),
            child: const Icon(Icons.close, size: 20, color: AppColors.onSurface),
          ),
          const SizedBox(width: 12),
          Text(
            'Refine Filters',
            style: AppTextStyles.headlineMd.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _clearAll,
            child: Text(
              'Clear All',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sort By ────────────────────────────────────────────────────────────────

  Widget _buildSortBy() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _sortOptions.map((option) {
        final active = _sortBy == option;
        return GestureDetector(
          onTap: () => setState(() => _sortBy = option),
          child: _FilterChip(label: option, active: active),
        );
      }).toList(),
    );
  }

  // ── Section wrapper ────────────────────────────────────────────────────────

  Widget _buildSection(
    String title,
    IconData icon,
    Widget content, {
    String? trailingLabel,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 0.5,
            color: const Color(0x14000000),
            margin: const EdgeInsets.only(bottom: 18),
          ),
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              if (trailingLabel != null)
                Text(
                  trailingLabel,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              if (actionLabel != null)
                GestureDetector(
                  onTap: onAction,
                  child: Text(
                    actionLabel,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          content,
        ],
      ),
    );
  }

  // ── Categories ─────────────────────────────────────────────────────────────

  Widget _buildCategories() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((cat) {
        final active = _selectedCategories.contains(cat);
        return GestureDetector(
          onTap: () => setState(() {
            if (active) {
              _selectedCategories.remove(cat);
            } else {
              _selectedCategories.add(cat);
            }
          }),
          child: _FilterChip(label: cat, active: active),
        );
      }).toList(),
    );
  }

  // ── Price range ────────────────────────────────────────────────────────────

  Widget _buildPriceRange(BuildContext context) {
    String formatNaira(double val) {
      final k = val / 1000;
      return k >= 1
          ? '₦${k % 1 == 0 ? k.toInt() : k.toStringAsFixed(1)}k'
          : '₦${val.toInt()}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Min / Max display boxes
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MINIMUM',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                        children: _buildNairaSpans(
                          formatNaira(_priceRange.start),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 36, color: AppColors.outlineVariant),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MAXIMUM',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          children: _buildNairaSpans(
                            formatNaira(_priceRange.end),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Dual-thumb range slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceContainerHigh,
            thumbColor: AppColors.primary,
            overlayColor: const Color(0x1AB80049),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: RangeSlider(
            values: _priceRange,
            min: 0,
            max: 200000,
            divisions: 40,
            onChanged: (values) => setState(() {
              _priceRange = values;
              _selectedPricePreset = null;
            }),
          ),
        ),
        const SizedBox(height: 14),
        // Preset chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _pricePresets.map((preset) {
            final (label, lo, hi) = preset;
            final active = _selectedPricePreset == label;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedPricePreset = label;
                _priceRange = RangeValues(lo, hi);
              }),
              child: _FilterChip(label: label, active: active),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Location & Delivery ────────────────────────────────────────────────────

  Widget _buildLocationDelivery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'POPULAR NEIGHBOURHOODS',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _neighborhoods.map((n) {
            final active = _selectedNeighborhoods.contains(n);
            return GestureDetector(
              onTap: () => setState(() {
                if (active) {
                  _selectedNeighborhoods.remove(n);
                } else {
                  _selectedNeighborhoods.add(n);
                }
              }),
              child: _FilterChip(label: n, active: active),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        _DeliveryToggle(
          icon: Icons.bolt_outlined,
          iconBgColor: const Color(0x1AB80049),
          iconColor: AppColors.primary,
          label: 'Same-Day Express Delivery',
          subtitle: 'Guaranteed delivery by 6:00 PM today',
          value: _sameDayEnabled,
          onChanged: (v) => setState(() => _sameDayEnabled = v),
        ),
        const SizedBox(height: 10),
        _DeliveryToggle(
          icon: Icons.send_to_mobile_outlined,
          iconBgColor: const Color(0x33FCD400),
          iconColor: AppColors.secondary,
          label: 'Instant Digital Delivery',
          subtitle: 'Send vouchers via SMS & WhatsApp',
          value: _instantEnabled,
          onChanged: (v) => setState(() => _instantEnabled = v),
        ),
      ],
    );
  }

  // ── Occasions ──────────────────────────────────────────────────────────────

  Widget _buildOccasions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _occasions.map((occ) {
        final (label, emoji) = occ;
        final active = _selectedOccasion == label;
        return GestureDetector(
          onTap: () =>
              setState(() => _selectedOccasion = active ? null : label),
          child: _FilterChip(label: '$emoji $label', active: active),
        );
      }).toList(),
    );
  }

  // ── Bottom action bar ──────────────────────────────────────────────────────

  Widget _buildBottomBar(BuildContext context, double bottomPad) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 16),
          decoration: const BoxDecoration(
            color: Color(0xF2F9F9F9),
            border: Border(
              top: BorderSide(color: Color(0x14000000), width: 0.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF22C55E).withAlpha(77),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '48 gifts match your criteria',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4DB80049),
                          blurRadius: 20,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0x33FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '48',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

// ---------------------------------------------------------------------------
// Supporting widgets
// ---------------------------------------------------------------------------

class _CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _CircleButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}

List<TextSpan> _buildNairaSpans(String text) {
  if (!text.contains('₦')) return [TextSpan(text: text)];
  final spans = <TextSpan>[];
  final parts = text.split('₦');
  for (int i = 0; i < parts.length; i++) {
    if (i > 0) {
      spans.add(const TextSpan(
        text: '₦',
        style: TextStyle(fontFamily: 'Roboto'),
      ));
    }
    if (parts[i].isNotEmpty) spans.add(TextSpan(text: parts[i]));
  }
  return spans;
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;

  const _FilterChip({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.symmetric(
        horizontal: active ? 12 : 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: active
            ? const [
                BoxShadow(
                  color: Color(0x40B80049),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (active) ...[
            const Icon(Icons.check, size: 14, color: Colors.white),
            const SizedBox(width: 5),
          ],
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? Colors.white : AppColors.onSurface,
                letterSpacing: 0.05,
              ),
              children: _buildNairaSpans(label),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryToggle extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DeliveryToggle({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.onSurfaceVariant,
            inactiveTrackColor: AppColors.surfaceContainerHigh,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

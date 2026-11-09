import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

class CheckoutDeliveryPage extends StatefulWidget {
  const CheckoutDeliveryPage({super.key});

  @override
  State<CheckoutDeliveryPage> createState() => _CheckoutDeliveryPageState();
}

class _CheckoutDeliveryPageState extends State<CheckoutDeliveryPage> {
  int _selectedDelivery = 0; // 0=Standard, 1=Express, 2=SameDay
  String _selectedDate = 'Friday, Sep 20';
  String _selectedWindow = 'Morning (9am – 12pm)';

  final _deliveryOptions = [
    _DeliveryOption(
      label: 'Standard',
      subtitle: '2–3 business days',
      price: '₦5,300',
      icon: Icons.local_shipping_outlined,
      tag: null,
    ),
    _DeliveryOption(
      label: 'Express',
      subtitle: 'Next business day',
      price: '₦5,300',
      icon: Icons.flash_on_outlined,
      tag: 'Popular',
    ),
    _DeliveryOption(
      label: 'Same Day',
      subtitle: 'Today by 6pm',
      price: '₦5,300',
      icon: Icons.rocket_launch_outlined,
      tag: 'Fastest',
    ),
  ];

  final _dateOptions = [
    'Friday, Sep 20',
    'Saturday, Sep 21',
    'Monday, Sep 23',
    'Tuesday, Sep 24',
  ];

  final _windowOptions = [
    'Morning (9am – 12pm)',
    'Afternoon (12pm – 4pm)',
    'Evening (4pm – 7pm)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      body: Stack(children: [
        _buildBody(context),
        Positioned(
          left: 0, right: 0, bottom: 0,
          child: _buildBottomBar(context),
        ),
      ]),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
        pinned: true,
        backgroundColor: const Color(0xFFF7F4EE),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.onSurfaceVariant,
          onPressed: () => context.pop(),
        ),
        title: Text('Forge Moments',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Stack(clipBehavior: Clip.none, children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.onSurfaceVariant,
                onPressed: () {},
              ),
              Positioned(
                top: 10, right: 10,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                ),
              ),
            ]),
          ),
        ],
      ),
      SliverToBoxAdapter(child: _buildHeader()),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 160),
        sliver: SliverList(delegate: SliverChildListDelegate([
          _buildDeliveryCards(),
          const SizedBox(height: 20),
          _buildScheduleCard(),
          const SizedBox(height: 16),
          _buildAiQuoteCard(),
        ])),
      ),
    ]);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Choose delivery',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: -0.5)),
        const SizedBox(height: 10),
        _buildStepIndicator(),
      ]),
    );
  }

  Widget _buildStepIndicator() {
    return Row(children: [
      Text('Curating',
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12, color: AppColors.onSurfaceVariant)),
      const Icon(Icons.chevron_right, size: 16, color: AppColors.onSurfaceVariant),
      Text('Personalizing',
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12, color: AppColors.onSurfaceVariant)),
      const Icon(Icons.chevron_right, size: 16, color: AppColors.onSurfaceVariant),
      Text('Sending',
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
    ]);
  }

  Widget _buildDeliveryCards() {
    return Column(
      children: List.generate(_deliveryOptions.length, (i) {
        final opt = _deliveryOptions[i];
        final selected = _selectedDelivery == i;
        return Padding(
          padding: EdgeInsets.only(bottom: i < _deliveryOptions.length - 1 ? 12 : 0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedDelivery = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.outlineVariant.withAlpha(100),
                    width: selected ? 1.5 : 1),
                boxShadow: [
                  BoxShadow(
                      color: selected
                          ? AppColors.primary.withAlpha(30)
                          : const Color(0x08000000),
                      blurRadius: selected ? 16 : 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withAlpha(30)
                        : AppColors.primaryFixed.withAlpha(120),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(opt.icon,
                      size: 22,
                      color: selected ? Colors.white : AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(opt.label,
                              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.onSurface)),
                          if (opt.tag != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white.withAlpha(40)
                                    : AppColors.primaryFixed,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(opt.tag!,
                                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: selected
                                          ? Colors.white
                                          : AppColors.primary)),
                            ),
                          ],
                        ]),
                        const SizedBox(height: 2),
                        Text(opt.subtitle,
                            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 12,
                                color: selected
                                    ? Colors.white.withAlpha(180)
                                    : AppColors.onSurfaceVariant)),
                      ]),
                ),
                Text.rich(TextSpan(
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.primary),
                  children: [
                    TextSpan(
                        text: '₦',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: selected ? Colors.white : AppColors.primary)),
                    TextSpan(text: opt.price.replaceFirst('₦', '')),
                  ],
                )),
              ]),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Text('Schedule Delivery',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
        ]),
        const SizedBox(height: 16),
        Text('Preferred Date',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dateOptions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final selected = _selectedDate == _dateOptions[i];
              final parts = _dateOptions[i].split(', ');
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = _dateOptions[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : const Color(0xFFFAF7F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.outlineVariant.withAlpha(100)),
                  ),
                  child: Text(
                      parts.length >= 2
                          ? '${parts[0].split(' ').first} ${parts[1]}'
                          : _dateOptions[i],
                      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.onSurface)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text('Preferred Time Window',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outlineVariant.withAlpha(128)),
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFFAF7F2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedWindow,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              borderRadius: BorderRadius.circular(12),
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], fontSize: 14, color: AppColors.onSurface),
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.onSurfaceVariant),
              items: _windowOptions
                  .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedWindow = v);
              },
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildAiQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x30000000), blurRadius: 16, offset: Offset(0, 6))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(40),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Forge AI Delivery Estimate',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
              Text('Based on your location & selected option',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 11, color: Colors.white54)),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: _buildQuoteStat(
                label: 'Estimated Cost',
                value: '₦5,300',
                valueStyle: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
          Container(width: 1, height: 40, color: Colors.white12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _buildQuoteStat(
                  label: 'Arriving',
                  value: _selectedDate.split(', ').first,
                  valueStyle: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            const Icon(Icons.verified_outlined, size: 15, color: Colors.white54),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                  'Delivery is tracked end-to-end. You\'ll receive real-time updates.',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 11, color: Colors.white54)),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildQuoteStat(
      {required String label,
      required String value,
      required TextStyle valueStyle}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 11, color: Colors.white54, letterSpacing: 0.5)),
      const SizedBox(height: 4),
      if (value.contains('₦'))
        Text.rich(TextSpan(
          style: valueStyle,
          children: [
            const TextSpan(
                text: '₦', style: TextStyle(fontFamily: 'Roboto')),
            TextSpan(text: value.replaceFirst('₦', '')),
          ],
        ))
      else
        Text(value, style: valueStyle),
    ]);
  }

  Widget _buildBottomBar(BuildContext context) {
    final opt = _deliveryOptions[_selectedDelivery];
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
          decoration: const BoxDecoration(
            color: Color(0xEAF7F4EE),
            border: Border(top: BorderSide(color: Color(0x1AB80049), width: 0.5)),
            boxShadow: [
              BoxShadow(color: Color(0x14B80049), blurRadius: 20, offset: Offset(0, -4))
            ],
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('DELIVERY FEE',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.8)),
                    const SizedBox(height: 2),
                    Text.rich(TextSpan(
                      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface),
                      children: [
                        const TextSpan(
                            text: '₦',
                            style: TextStyle(fontFamily: 'Roboto')),
                        TextSpan(text: opt.price.replaceFirst('₦', '')),
                      ],
                    )),
                  ]),
            ),
            const SizedBox(width: 16),
            FilledButton(
              onPressed: () => context.push(AppRoutes.checkoutReview),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Continue',
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onPrimary)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DeliveryOption {
  final String label, subtitle, price;
  final IconData icon;
  final String? tag;
  const _DeliveryOption({
    required this.label,
    required this.subtitle,
    required this.price,
    required this.icon,
    required this.tag,
  });
}

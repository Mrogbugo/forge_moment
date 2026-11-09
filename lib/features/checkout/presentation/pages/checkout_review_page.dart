import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';

class CheckoutReviewPage extends StatefulWidget {
  const CheckoutReviewPage({super.key});

  @override
  State<CheckoutReviewPage> createState() => _CheckoutReviewPageState();
}

class _CheckoutReviewPageState extends State<CheckoutReviewPage> {
  int _selectedPackaging = 1; // 0=Velvet, 1=Wooden, 2=Eco
  bool _useWallet = false;

  // Amounts in kobo/minor units displayed as formatted strings
  static const int _subtotal = 100000;
  static const int _delivery = 5300;
  static const int _service = 500;
  static const int _walletBalance = 45000;

  final _packagingOptions = [
    _PackagingOption(
      label: 'Velvet Box',
      desc: 'Luxurious velvet finish',
      price: 3500,
      emoji: '🎁',
      color: const Color(0xFF8B2635),
    ),
    _PackagingOption(
      label: 'Wooden Box',
      desc: 'Keepsake wooden crate',
      price: 5000,
      emoji: '📦',
      color: const Color(0xFF8B6914),
    ),
    _PackagingOption(
      label: 'Eco Wrap',
      desc: 'Sustainable packaging',
      price: 0,
      emoji: '🌿',
      color: const Color(0xFF2E7D32),
    ),
  ];

  int get _packagingCost => _packagingOptions[_selectedPackaging].price;

  int get _total {
    final raw = _subtotal + _delivery + _service + _packagingCost;
    if (_useWallet) return (raw - _walletBalance).clamp(0, raw);
    return raw;
  }

  String _fmt(int amount) {
    final s = amount.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write(',');
      result.write(s[i]);
    }
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
        backgroundColor: AppColors.surface.withAlpha(204),
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
          _buildPackagingSection(),
          const SizedBox(height: 20),
          _buildDeliverySummary(),
          const SizedBox(height: 20),
          _buildPaymentBreakdown(),
        ])),
      ),
    ]);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Review & Pay',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: -0.5)),
        const SizedBox(height: 12),
        _buildProgressBar(),
      ]),
    );
  }

  Widget _buildProgressBar() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _buildStep(label: 'Cart', done: true),
        _buildConnector(done: true),
        _buildStep(label: 'Delivery', done: true),
        _buildConnector(done: true),
        _buildStep(label: 'Review', active: true),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: 1.0,
          backgroundColor: AppColors.outlineVariant.withAlpha(80),
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          minHeight: 4,
        ),
      ),
    ]);
  }

  Widget _buildStep({required String label, bool done = false, bool active = false}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          color: done || active ? AppColors.primary : AppColors.outlineVariant.withAlpha(80),
          shape: BoxShape.circle,
        ),
        child: done
            ? const Icon(Icons.check, size: 12, color: Colors.white)
            : Center(
                child: Text(
                    active ? '3' : '',
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
      ),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: done || active ? AppColors.primary : AppColors.onSurfaceVariant)),
    ]);
  }

  Widget _buildConnector({bool done = false}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: done ? AppColors.primary : AppColors.outlineVariant.withAlpha(80),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildPackagingSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Text('Choose Packaging',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
        ]),
        const SizedBox(height: 4),
        Text('How should your moment be presented?',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 12, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 16),
        ...List.generate(_packagingOptions.length, (i) {
          final opt = _packagingOptions[i];
          final selected = _selectedPackaging == i;
          return Padding(
            padding: EdgeInsets.only(bottom: i < _packagingOptions.length - 1 ? 10 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPackaging = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary.withAlpha(12)
                      : AppColors.surface.withAlpha(200),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: selected ? AppColors.primary : AppColors.outlineVariant.withAlpha(100),
                      width: selected ? 1.5 : 1),
                ),
                child: Row(children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: opt.color.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(opt.emoji,
                          style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(opt.label,
                          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface)),
                      Text(opt.desc,
                          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 11, color: AppColors.onSurfaceVariant)),
                    ]),
                  ),
                  if (opt.price == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withAlpha(20),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('Free',
                          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E7D32))),
                    )
                  else
                    Text.rich(TextSpan(
                      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: selected ? AppColors.primary : AppColors.onSurface),
                      children: [
                        const TextSpan(
                            text: '₦',
                            style: TextStyle(fontFamily: 'Roboto')),
                        TextSpan(text: _fmt(opt.price)),
                      ],
                    )),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                          width: 1.5),
                    ),
                    child: selected
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
                ]),
              ),
            ),
          );
        }),
      ]),
    );
  }

  Widget _buildDeliverySummary() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Text('Delivery Summary',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
        ]),
        const SizedBox(height: 16),
        _buildSummaryRow(
            icon: Icons.person_outline,
            label: 'Recipient',
            value: 'Chioma Okafor'),
        const SizedBox(height: 12),
        _buildSummaryRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: '12 Balogun St, VI, Lagos'),
        const SizedBox(height: 12),
        _buildSummaryRow(
            icon: Icons.flash_on_outlined,
            label: 'Delivery',
            value: 'Express · Fri, Sep 20'),
        const SizedBox(height: 12),
        _buildSummaryRow(
            icon: Icons.access_time_outlined,
            label: 'Window',
            value: 'Morning (9am – 12pm)'),
      ]),
    );
  }

  Widget _buildSummaryRow(
      {required IconData icon, required String label, required String value}) {
    return Row(children: [
      Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
      const SizedBox(width: 10),
      Text('$label  ',
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 13, color: AppColors.onSurfaceVariant)),
      Expanded(
        child: Text(value,
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface),
            textAlign: TextAlign.end),
      ),
    ]);
  }

  Widget _buildPaymentBreakdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Text('Payment Breakdown',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
        ]),
        const SizedBox(height: 16),
        _buildAmountRow(label: 'Subtotal (2 items)', amount: _subtotal),
        const SizedBox(height: 10),
        _buildAmountRow(label: 'Delivery fee', amount: _delivery),
        const SizedBox(height: 10),
        _buildAmountRow(label: 'Service fee', amount: _service),
        if (_packagingCost > 0) ...[
          const SizedBox(height: 10),
          _buildAmountRow(
              label: 'Packaging · ${_packagingOptions[_selectedPackaging].label}',
              amount: _packagingCost),
        ],
        const SizedBox(height: 16),
        Container(height: 1, color: AppColors.outlineVariant.withAlpha(80)),
        const SizedBox(height: 16),
        // Wallet toggle
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _useWallet
                ? AppColors.primary.withAlpha(12)
                : const Color(0xFFFAF7F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: _useWallet
                    ? AppColors.primary.withAlpha(80)
                    : AppColors.outlineVariant.withAlpha(100)),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.account_balance_wallet_outlined,
                  size: 18, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Use Forge Wallet',
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                Text.rich(TextSpan(
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 11, color: AppColors.onSurfaceVariant),
                  children: [
                    const TextSpan(text: 'Balance: '),
                    const TextSpan(
                        text: '₦',
                        style: TextStyle(fontFamily: 'Roboto')),
                    TextSpan(text: _fmt(_walletBalance)),
                  ],
                )),
              ]),
            ),
            Switch(
              value: _useWallet,
              onChanged: (v) => setState(() => _useWallet = v),
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ]),
        ),
        if (_useWallet) ...[
          const SizedBox(height: 10),
          _buildAmountRow(
              label: 'Wallet credit',
              amount: -_walletBalance.clamp(
                  0, _subtotal + _delivery + _service + _packagingCost),
              isCredit: true),
        ],
        const SizedBox(height: 16),
        Container(height: 1.5, color: AppColors.outlineVariant.withAlpha(100)),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
          Text.rich(TextSpan(
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary),
            children: [
              const TextSpan(
                  text: '₦', style: TextStyle(fontFamily: 'Roboto')),
              TextSpan(text: _fmt(_total)),
            ],
          )),
        ]),
      ]),
    );
  }

  Widget _buildAmountRow(
      {required String label, required int amount, bool isCredit = false}) {
    final displayAmount = amount.abs();
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label,
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 13, color: AppColors.onSurfaceVariant)),
      Text.rich(TextSpan(
        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isCredit ? const Color(0xFF2E7D32) : AppColors.onSurface),
        children: [
          if (isCredit) const TextSpan(text: '–'),
          TextSpan(
              text: '₦',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  color: isCredit ? const Color(0xFF2E7D32) : AppColors.onSurface)),
          TextSpan(text: _fmt(displayAmount)),
        ],
      )),
    ]);
  }

  Widget _buildBottomBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
          decoration: const BoxDecoration(
            color: Color(0xEAF9F9F9),
            border: Border(top: BorderSide(color: Color(0x1AB80049), width: 0.5)),
            boxShadow: [
              BoxShadow(color: Color(0x14B80049), blurRadius: 20, offset: Offset(0, -4))
            ],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('TOTAL DUE',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 0.8)),
              Text.rich(TextSpan(
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                children: [
                  const TextSpan(
                      text: '₦', style: TextStyle(fontFamily: 'Roboto')),
                  TextSpan(text: _fmt(_total)),
                ],
              )),
            ]),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _confirmAndPay(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: Text.rich(TextSpan(
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary),
                  children: [
                    const TextSpan(text: 'Confirm & Pay  '),
                    const TextSpan(
                        text: '₦',
                        style: TextStyle(
                            fontFamily: 'Roboto', color: AppColors.onPrimary)),
                    TextSpan(text: _fmt(_total)),
                  ],
                )),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _confirmAndPay(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Confirm Payment',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary)),
        content: Text.rich(TextSpan(
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], fontSize: 14, color: AppColors.onSurface),
          children: [
            const TextSpan(text: 'You are about to pay '),
            const TextSpan(
                text: '₦', style: TextStyle(fontFamily: 'Roboto')),
            TextSpan(
                text: _fmt(_total),
                style: const TextStyle(fontWeight: FontWeight.w700)),
            const TextSpan(text: ' to complete your Forge Moment.'),
          ],
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], color: AppColors.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: trigger payment
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: const StadiumBorder(),
            ),
            child: Text('Pay Now',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontWeight: FontWeight.w700, color: AppColors.onPrimary)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PackagingOption {
  final String label, desc, emoji;
  final int price;
  final Color color;
  const _PackagingOption({
    required this.label,
    required this.desc,
    required this.price,
    required this.emoji,
    required this.color,
  });
}

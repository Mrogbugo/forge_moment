import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _messageCtrl = TextEditingController();
  final _inscriptionCtrl = TextEditingController(text: 'Gc');
  final _fromCtrl = TextEditingController(text: 'Arinze');

  @override
  void dispose() {
    _messageCtrl.dispose();
    _inscriptionCtrl.dispose();
    _fromCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [
        _buildBody(),
        Positioned(
          left: 0, right: 0, bottom: 0,
          child: _buildBottomBar(context),
        ),
      ]),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(slivers: [
      SliverAppBar(
        pinned: true,
        backgroundColor: AppColors.surface.withAlpha(204),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.onSurfaceVariant,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text('Forge Moments',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
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
          _CartItemCard(
            name: 'Luxury Rose Box',
            desc: 'Premium Ecuadorian roses in a signature velvet box.',
            price: '₦35,000',
            color: const Color(0xFF8B2635),
          ),
          const SizedBox(height: 12),
          _CartItemCard(
            name: 'Spa Retreat',
            desc: 'Full day access for two at the grand hotel spa.',
            price: '₦65,000',
            color: const Color(0xFF4A7B8A),
          ),
          const SizedBox(height: 20),
          _buildPersonalisation(),
        ])),
      ),
    ]);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Build Your Moment',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Row(children: [
          Text('Curating',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.onSurfaceVariant),
          Text('Personalizing',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], fontSize: 12, color: AppColors.onSurfaceVariant)),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.onSurfaceVariant),
          Text('Sending',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], fontSize: 12, color: AppColors.onSurfaceVariant)),
        ]),
      ]),
    );
  }

  Widget _buildPersonalisation() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.redeem_outlined, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Personalise your Moment',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            const SizedBox(height: 2),
            Text('Your personalisation will be applied to all selected gifts.',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], fontSize: 12, color: AppColors.onSurfaceVariant)),
          ])),
        ]),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.surface.withAlpha(128),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Message (optional · ₦1,000)',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
              ListenableBuilder(
                listenable: _messageCtrl,
                builder: (_, __) => Text('${_messageCtrl.text.length}/1000',
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 11, color: AppColors.onSurfaceVariant)),
              ),
            ]),
            const SizedBox(height: 8),
            TextField(
              controller: _messageCtrl,
              maxLines: 4,
              maxLength: 1000,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], fontSize: 14, color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Write a thoughtful message...',
                hintStyle: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14, color: AppColors.onSurfaceVariant.withAlpha(153)),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outlineVariant)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outlineVariant.withAlpha(128))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary)),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                    color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(999)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.auto_awesome, size: 15, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text('Help me write this',
                      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Inscription',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
              Text('Optional · 2/80',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 11, color: AppColors.onSurfaceVariant)),
            ]),
            const SizedBox(height: 6),
            TextField(
              controller: _inscriptionCtrl,
              maxLength: 80,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], fontSize: 14, color: AppColors.onSurface),
              decoration: InputDecoration(
                filled: true, fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outlineVariant)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outlineVariant.withAlpha(128))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _fromCtrl,
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], fontSize: 14, color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'From (your name)',
                hintStyle: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14, color: AppColors.onSurfaceVariant.withAlpha(153)),
                filled: true, fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outlineVariant)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outlineVariant.withAlpha(128))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ]),
        ),
      ]),
    );
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
            boxShadow: [BoxShadow(color: Color(0x14B80049), blurRadius: 20, offset: Offset(0, -4))],
          ),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('SUBTOTAL (2 ITEMS)',
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 0.8)),
                const SizedBox(height: 2),
                Text.rich(TextSpan(
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                  children: const [
                    TextSpan(text: '₦', style: TextStyle(fontFamily: 'Roboto')),
                    TextSpan(text: '100,000'),
                  ],
                )),
              ]),
            ),
            const SizedBox(width: 16),
            FilledButton(
              onPressed: () => context.push(AppRoutes.checkoutRecipient),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Continue',
                    style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onPrimary)),
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

class _CartItemCard extends StatelessWidget {
  final String name, desc, price;
  final Color color;
  const _CartItemCard({
    required this.name,
    required this.desc,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(179),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(77)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withAlpha(13),
                  blurRadius: 24,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Row(children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color, color.withAlpha(153)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.redeem_rounded, color: Colors.white54, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 80,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(name,
                            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface)),
                        Text(desc,
                            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 12, color: AppColors.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text.rich(TextSpan(
                          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                          children: [
                            const TextSpan(text: '₦', style: TextStyle(fontFamily: 'Roboto')),
                            TextSpan(text: price.replaceFirst('₦', '')),
                          ],
                        )),
                        Row(children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.edit_outlined,
                                  size: 20, color: AppColors.onSurfaceVariant),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                            ),
                          ),
                        ]),
                      ]),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

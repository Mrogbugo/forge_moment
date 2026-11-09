import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

class CheckoutRecipientPage extends StatefulWidget {
  const CheckoutRecipientPage({super.key});

  @override
  State<CheckoutRecipientPage> createState() => _CheckoutRecipientPageState();
}

class _CheckoutRecipientPageState extends State<CheckoutRecipientPage> {
  final _nameCtrl = TextEditingController(text: 'Chioma Okafor');
  final _phoneCtrl = TextEditingController(text: '+234 803 456 7890');
  final _addressCtrl = TextEditingController(
      text: '12 Balogun Street, Victoria Island');
  final _cityCtrl = TextEditingController(text: 'Lagos');
  final _stateCtrl = TextEditingController(text: 'Lagos State');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
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
        backgroundColor: const Color(0xFFFAF7F2),
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
          _buildMapCard(),
          const SizedBox(height: 16),
          _buildFormCard(),
        ])),
      ),
    ]);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Where should\nwe deliver?',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: -0.5,
                height: 1.2)),
        const SizedBox(height: 10),
        _buildStepIndicator(),
      ]),
    );
  }

  Widget _buildStepIndicator() {
    return Row(children: [
      Text('Curating',
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
      const Icon(Icons.chevron_right, size: 16, color: AppColors.onSurfaceVariant),
      Text('Personalizing',
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
      const Icon(Icons.chevron_right, size: 16, color: AppColors.onSurfaceVariant),
      Text('Sending',
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12, color: AppColors.onSurfaceVariant)),
    ]);
  }

  Widget _buildMapCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFE8EAD5),
        boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        // Simulated map grid
        CustomPaint(painter: _MapGridPainter(), size: const Size.fromHeight(200)),
        // Map label
        Positioned(
          top: 16, left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 4)],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.map_outlined, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text('Delivery Location',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
            ]),
          ),
        ),
        // Pin marker in center
        Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(77), blurRadius: 12)],
              ),
              child: const Icon(Icons.place, color: Colors.white, size: 22),
            ),
            CustomPaint(painter: _PinTailPainter(), size: const Size(12, 8)),
          ]),
        ),
        // Address overlay at bottom
        Positioned(
          left: 12, right: 12, bottom: 12,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(230),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withAlpha(150)),
                ),
                child: Row(children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('12 Balogun St, Victoria Island, Lagos',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurface),
                        overflow: TextOverflow.ellipsis),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text('Change',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.person_outline, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Text('Recipient Details',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
        ]),
        const SizedBox(height: 4),
        Text('Who will receive this moment?',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 12, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 20),
        _buildField(label: 'Full Name', controller: _nameCtrl),
        const SizedBox(height: 14),
        _buildField(
            label: 'Phone Number',
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone),
        const SizedBox(height: 20),
        Row(children: [
          const Icon(Icons.home_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Text('Delivery Address',
              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
        ]),
        const SizedBox(height: 16),
        _buildField(
            label: 'Street Address',
            controller: _addressCtrl),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: _buildField(
                label: 'City', controller: _cityCtrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildField(
                label: 'State', controller: _stateCtrl),
          ),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryFixed.withAlpha(80),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                  'We\'ll send delivery updates to the phone number provided.',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 12, color: AppColors.primary)),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'], fontSize: 14, color: AppColors.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFAF7F2),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.outlineVariant)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.outlineVariant.withAlpha(128))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
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
            color: Color(0xEAFAF7F2),
            border: Border(top: BorderSide(color: Color(0x1AB80049), width: 0.5)),
            boxShadow: [BoxShadow(color: Color(0x14B80049), blurRadius: 20, offset: Offset(0, -4))],
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('DELIVERY TO',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.8)),
                    const SizedBox(height: 2),
                    Text('Victoria Island, Lagos',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface)),
                  ]),
            ),
            const SizedBox(width: 16),
            FilledButton(
              onPressed: () => context.push(AppRoutes.checkoutDelivery),
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

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD5D8C0)
      ..strokeWidth = 1;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Simulate roads
    final roadPaint = Paint()
      ..color = const Color(0xFFF5F3EC)
      ..strokeWidth = 8;
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), roadPaint);
    canvas.drawLine(Offset(size.width * 0.65, 0), Offset(size.width * 0.65, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

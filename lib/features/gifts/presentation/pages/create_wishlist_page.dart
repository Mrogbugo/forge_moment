import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

// Secondary palette
const _secondary = Color(0xFF685D4A);
const _secondaryContainer = Color(0xFFEDDEC5);
const _onSecondaryContainer = Color(0xFF6C614E);
const _secondaryFixed = Color(0xFFF0E0C8);
const _onSecondaryFixed = Color(0xFF221B0B);

class CreateWishlistPage extends StatefulWidget {
  const CreateWishlistPage({super.key});

  @override
  State<CreateWishlistPage> createState() => _CreateWishlistPageState();
}

class _CreateWishlistPageState extends State<CreateWishlistPage> {
  String _title = 'My 30th Milestone Birthday';
  String _occasion = 'Birthday';
  String _date = 'Oct 28, 2025';
  bool _showStorePanel = true;
  bool _allowPartial = true;
  bool _keepSecret = true;
  bool _isSubmitting = false;

  late final TextEditingController _titleController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: _title);
    _dateController = TextEditingController(text: _date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2025, 10, 28),
      firstDate: now,
      lastDate: DateTime(2030, 12, 31),
    );
    if (picked != null && mounted) {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final formatted = '${months[picked.month - 1]} ${picked.day}, ${picked.year}';
      setState(() {
        _date = formatted;
        _dateController.text = formatted;
      });
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    context.pushNamed(
      AppRoutes.nameShareWishlist,
      pathParameters: {'wishlistId': 'sarah-bday-28'},
    );
  }

  InputDecoration _fieldDecoration({
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create Wishlist',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: ['Montserrat Fallback'],
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 120 + bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildProgressCard(),
                const SizedBox(height: 16),
                _buildMomentDetailsCard(),
                const SizedBox(height: 16),
                _buildTabSwitcher(),
                const SizedBox(height: 12),
                if (_showStorePanel) _buildStorePanel() else _buildCashPanel(),
                const SizedBox(height: 16),
                _buildPrivacyCard(),
                const SizedBox(height: 16),
                _buildSummaryCard(),
              ],
            ),
          ),
          _buildStickyBottom(bottomPadding),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '1',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    color: AppColors.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Step 1 of 2',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              const Text(
                'Details & Curations',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  color: _secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: const LinearProgressIndicator(
              value: 0.5,
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceContainerHighest,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
              SizedBox(width: 8),
              Text(
                'Moment Details',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Wishlist Title',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            onChanged: (v) => _title = v,
            decoration: _fieldDecoration(),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Celebration Type',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _occasion,
            decoration: _fieldDecoration(),
            icon: const Icon(Icons.expand_more, color: AppColors.onSurfaceVariant),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontSize: 16,
              color: AppColors.onSurface,
            ),
            items: const [
              DropdownMenuItem(value: 'Birthday', child: Text('Birthday')),
              DropdownMenuItem(value: 'Anniversary', child: Text('Anniversary')),
              DropdownMenuItem(value: 'Wedding', child: Text('Wedding')),
              DropdownMenuItem(value: 'Graduation', child: Text('Graduation')),
              DropdownMenuItem(value: 'Just Because', child: Text('Just Because')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _occasion = v);
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Target Celebration Date',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: _pickDate,
            decoration: _fieldDecoration(
              prefixIcon: const Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
            ),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(99),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(child: _buildTab(
            label: 'Store Products (2)',
            icon: Icons.redeem,
            active: _showStorePanel,
            onTap: () => setState(() => _showStorePanel = true),
          )),
          Expanded(child: _buildTab(
            label: 'Cash Gifts (1)',
            icon: Icons.payments,
            active: !_showStorePanel,
            onTap: () => setState(() => _showStorePanel = false),
          )),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.surfaceContainerLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
          boxShadow: active
              ? const [BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: active ? AppColors.primary : AppColors.onSurfaceVariant),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Store Items Added',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Text(
                '2 Selected',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  color: AppColors.onPrimaryFixed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Verified Vendors',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 12,
                color: _secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStoreItemCard(
          name: 'The Floral Brushstroke Cake',
          vendor: 'Divinebakes',
          price: '₦24,750',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCgncygG1SKw8pYLkH7KaSqF7lLpVkUb-oU_jNgc6qRcQVDzQthhLur9trIJmshJ9RnDeK8yohwvQkzoZJdaetCHnUG5-PFiD3Lx6eZzn3LbFZ-af90bFGWWnObVB5MQu2Z1ldZ00WEB-yG5OY6FX4FuURz6Am4MFEKFvHclPJrAz8DyA6_dPN6dwHdcHB5_1QsRQaGJ9oc1Roid12ETyN-TCPM3jX-aJMkl-RWX6-7qN_ug4PzqdX5iQ',
        ),
        const SizedBox(height: 12),
        _buildStoreItemCard(
          name: 'Luxury Rose Box',
          vendor: 'Rose Garden',
          price: '₦35,000',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAzHGNcP6RyQmMTZOPXxW6mF4HERueYIK8MhVdDckAgLFpxfbkSXnGBWsBkuiO70Aps131vl3xiON9yrTEsslfLvFAwo_lT17VYl36wI1TYGkfOosQyHAc8ggGl9takzWykO0I8JKIZ_gTetCN-ef8hS0zk1sLjBYzuGUR_VaoNV75rE5FOu5nDM34N3rxDTKi4UEUej2IzZkTd_GPnJV9bMrmqxwy3EKJxV4HZCaXOIVHRCgipJduCYg',
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            label: const Text(
              'Browse Store for More Items',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerLow,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildStoreItemCard({
    required String name,
    required String vendor,
    required String price,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceContainerLow,
              ),
              errorWidget: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceContainerLow,
                child: const Icon(Icons.image_not_supported, color: AppColors.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  vendor,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 12,
                    color: _secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text(
                    'Qty: 1',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: ['Montserrat Fallback'],
                      fontSize: 12,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: AppColors.outline, size: 18),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildCashPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Money Packages',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _secondaryFixed,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Text(
                '1 Configured',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  color: _onSecondaryFixed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Crowdfund Ready',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                fontSize: 12,
                color: _secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_wallet, color: _onSecondaryContainer, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bespoke Cash Gift Box',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: ['Montserrat Fallback'],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          'Flexible contribution',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: ['Montserrat Fallback'],
                            fontSize: 12,
                            color: _secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.outline, size: 18),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Target Amount Goal',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '₦50,000',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Montserrat Fallback'],
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"Towards my master photography masterclass"',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.savings_outlined, color: _secondary),
            label: const Text(
              'Add Airtime or Money Package',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Montserrat Fallback'],
                color: _secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerLow,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.shield, color: _secondary, size: 20),
              SizedBox(width: 8),
              Text(
                'Gifting Etiquette & Privacy',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSwitchRow(
            title: 'Allow partial cash contributions',
            subtitle: 'Friends can pool together...',
            value: _allowPartial,
            onChanged: (v) => setState(() => _allowPartial = v),
          ),
          const Divider(height: 24, color: AppColors.outlineVariant),
          _buildSwitchRow(
            title: 'Keep surprises secret',
            subtitle: 'Reveal who bought what only on event day',
            value: _keepSecret,
            onChanged: (v) => setState(() => _keepSecret = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Curated Items (3)',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                '2 Gifts + 1 Cash Fund',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Estimated Wishlist Value',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '₦109,750',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Montserrat Fallback'],
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Guests can contribute easily via cards, transfer, or split payments.',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Montserrat Fallback'],
              fontSize: 12,
              color: _secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottom(double bottomPadding) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withAlpha(230),
              boxShadow: const [
                BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4)),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomPadding),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save & Generate Shareable Link',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: ['Montserrat Fallback'],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

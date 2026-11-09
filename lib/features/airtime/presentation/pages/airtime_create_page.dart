import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_search_field.dart';
import '../../domain/repositories/airtime_repository.dart';
import '../blocs/airtime_cubit.dart';

// FR-AIR-002: amount per claimant + max claims (within server limits)
// FR-AIR-003: show pool face value, fees, total (server is authoritative)
// FR-AIR-004: personalize — sender name, message, cover, media/music, anonymity
// FR-AIR-005: validate funded value can satisfy per-person × claim count
// FR-AIR-006: auth gate at payment/send if guest
// FR-AIR-011: explain one-claim-per-number and provider delay
class AirtimeCreatePage extends StatefulWidget {
  const AirtimeCreatePage({super.key});

  @override
  State<AirtimeCreatePage> createState() => _AirtimeCreatePageState();
}

class _AirtimeCreatePageState extends State<AirtimeCreatePage> {
  // ── Wizard step (0–4) ──────────────────────────────────────────────────────
  int _step = 0;

  // Step 1 — Gift type
  bool _isSingleGift = true;

  // Step 2 — Personalise
  final _nameCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _anonymous = false;

  // Step 3 — Cover
  int _selectedCoverIndex = 0;

  // Step 4 — Music
  final _musicCtrl = TextEditingController();
  int? _selectedMusicIndex; // null = No Music

  // Step 5 — Amount (single)
  final _amountCtrl = TextEditingController(text: '500');
  final _claimsCtrl = TextEditingController(text: '1');

  // Step 5 — Amount (bulk)
  final _totalAmountCtrl = TextEditingController(text: '10000');
  final _amountPerPersonCtrl = TextEditingController(text: '1000');
  bool _batchClaims = false;

  // ── Computed fee values ────────────────────────────────────────────────────
  double get _amountPerClaim => _isSingleGift
      ? (double.tryParse(_amountCtrl.text) ?? 0)
      : (double.tryParse(_amountPerPersonCtrl.text) ?? 0);

  int get _maxClaims {
    if (_isSingleGift) return 1;
    final total = double.tryParse(_totalAmountCtrl.text) ?? 0;
    final per = double.tryParse(_amountPerPersonCtrl.text) ?? 0;
    if (per <= 0) return 0;
    return (total / per).floor();
  }

  double get _poolTotal => _isSingleGift
      ? _amountPerClaim
      : (double.tryParse(_totalAmountCtrl.text) ?? 0);

  // Platform fee: 1.5% when pool total exceeds ₦500 — FR-AIR-003
  double get _platformFee => _poolTotal > 500 ? _poolTotal * 0.015 : 0;
  double get _grandTotal => _poolTotal + _platformFee;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _messageCtrl.dispose();
    _musicCtrl.dispose();
    _amountCtrl.dispose();
    _claimsCtrl.dispose();
    _totalAmountCtrl.dispose();
    _amountPerPersonCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step < 4) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  void _submit() {
    context.read<AirtimeCubit>().createPool(
          amountPerClaim: _amountPerClaim,
          maxClaims: _maxClaims,
          message: _messageCtrl.text.trim().isEmpty
              ? null
              : _messageCtrl.text.trim(),
          anonymous: _anonymous,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AirtimeCubit(
        repository: GetIt.instance<AirtimeRepository>(),
      ),
      child: BlocConsumer<AirtimeCubit, AirtimeState>(
      listener: (context, state) {
        if (state.step == AirtimeStep.payment && state.pool != null) {
          context.pushReplacementNamed(
            AppRoutes.nameAirtimeSuccess,
            extra: <String, String>{
              'poolId': state.pool!.id,
              'publicLink': state.pool!.publicLink ?? '',
            },
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!,
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'])),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, airtimeState) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Column(
            children: [
              _AirtimeHeader(onBack: () => context.pop()),
              _StepProgressBar(currentStep: _step),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: _buildStep(),
                ),
              ),
              _ActionBar(
                step: _step,
                isLoading: airtimeState.isLoading,
                poolTotal: _poolTotal,
                platformFee: _platformFee,
                grandTotal: _grandTotal,
                onBack: _prevStep,
                onContinue: _nextStep,
              ),
            ],
          ),
        );
      },
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _Step1GiftType(
          isSingle: _isSingleGift,
          onChanged: (v) => setState(() => _isSingleGift = v),
        );
      case 1:
        return _Step2Personalise(
          isSingle: _isSingleGift,
          nameCtrl: _nameCtrl,
          messageCtrl: _messageCtrl,
        );
      case 2:
        return _Step3Cover(
          selectedIndex: _selectedCoverIndex,
          onSelected: (i) => setState(() => _selectedCoverIndex = i),
        );
      case 3:
        return _Step4Music(musicCtrl: _musicCtrl);
      case 4:
        return _Step5Amount(
          isSingle: _isSingleGift,
          amountCtrl: _amountCtrl,
          claimsCtrl: _claimsCtrl,
          totalAmountCtrl: _totalAmountCtrl,
          amountPerPersonCtrl: _amountPerPersonCtrl,
          batchClaims: _batchClaims,
          onBatchClaimsChanged: (v) => setState(() => _batchClaims = v),
          onChanged: () => setState(() {}),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header — back button + "Forge Moments" logo
// ─────────────────────────────────────────────────────────────────────────────

class _AirtimeHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _AirtimeHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
              color: AppColors.surfaceVariant, width: 0.5),
        ),
      ),
      padding: EdgeInsets.only(
        top: top + 4,
        left: 4,
        right: 20,
        bottom: 12,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            color: AppColors.onSurfaceVariant,
          ),
          // Logo mark — rose circle with F initial
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'F',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Forge Moments',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step progress — label row + 5 animated horizontal bars
// ─────────────────────────────────────────────────────────────────────────────

const _kStepLabels = [
  'Gift type',
  'Message',
  'Cover',
  'Music',
  'Amount',
];

class _StepProgressBar extends StatelessWidget {
  final int currentStep;

  const _StepProgressBar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Step ${currentStep + 1} of 5',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                _kStepLabels[currentStep],
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              5,
              (i) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  margin: EdgeInsets.only(right: i < 4 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: i <= currentStep
                        ? AppColors.primary
                        : AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Envelope card — shared container for each step
// ─────────────────────────────────────────────────────────────────────────────

class _EnvelopeCard extends StatelessWidget {
  final IconData icon;
  final String heading;
  final Widget child;
  /// When true: icon container uses full primary bg + onPrimary icon colour.
  /// When false (default): uses primaryFixed bg + primary icon colour.
  final bool iconOnPrimary;
  /// When set: overrides the icon background colour entirely (icon is white).
  final Color? iconBackgroundColor;
  /// When true: a thin divider is drawn between the heading row and content.
  final bool showHeadingDivider;

  const _EnvelopeCard({
    required this.icon,
    required this.heading,
    required this.child,
    this.iconOnPrimary = false,
    this.iconBackgroundColor,
    this.showHeadingDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14E61A61),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackgroundColor ??
                      (iconOnPrimary
                          ? AppColors.primary
                          : AppColors.primaryFixed),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: (iconOnPrimary || iconBackgroundColor != null)
                      ? const [
                          BoxShadow(
                            color: Color(0x33B80049),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  color: (iconOnPrimary || iconBackgroundColor != null)
                      ? AppColors.onPrimary
                      : AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  heading,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          if (showHeadingDivider) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 0.5, color: AppColors.surfaceVariant),
          ],
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — Choose Gift Type (2-column grid)
// ─────────────────────────────────────────────────────────────────────────────

class _Step1GiftType extends StatelessWidget {
  final bool isSingle;
  final ValueChanged<bool> onChanged;

  const _Step1GiftType({required this.isSingle, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _EnvelopeCard(
      icon: Icons.card_giftcard_outlined,
      heading: 'Choose Gift Type',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _GiftTypeCard(
                  icon: Icons.redeem_rounded,
                  label: 'Single Card',
                  isSelected: isSingle,
                  onTap: () => onChanged(true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _GiftTypeCard(
                  icon: Icons.layers_outlined,
                  label: 'Bulk Cards',
                  isSelected: !isSingle,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              isSingle
                  ? 'One recipient can claim this airtime gift.'
                  : 'Multiple recipients can each claim airtime from this pool.',
              key: ValueKey(isSingle),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 14,
                color: AppColors.onSurfaceVariant.withAlpha(200),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GiftTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GiftTypeCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(13)  // ~5% opacity
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withAlpha(26)  // ~10% opacity
                    : AppColors.surfaceVariant.withAlpha(128),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.outline,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 — Personalise Gift
// ─────────────────────────────────────────────────────────────────────────────

class _Step2Personalise extends StatelessWidget {
  final bool isSingle;
  final TextEditingController nameCtrl;
  final TextEditingController messageCtrl;

  const _Step2Personalise({
    required this.isSingle,
    required this.nameCtrl,
    required this.messageCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return _EnvelopeCard(
      icon: Icons.edit_outlined,
      heading: 'Personalize Gift',
      iconOnPrimary: true,
      showHeadingDivider: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Step2Label('Recipient Name'),
          const SizedBox(height: 8),
          _Step2Field(
            controller: nameCtrl,
            hint: isSingle ? 'Who is this gift for?' : 'Friends, Family and Team',
            inputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          _Step2Label('Your Message'),
          const SizedBox(height: 8),
          _Step2Field(
            controller: messageCtrl,
            hint: 'Sending you some airtime love for those long catch-up calls! 💝',
            maxLines: 4,
            inputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}

/// Uppercase tracking-wider label for Step 2 fields.
class _Step2Label extends StatelessWidget {
  final String text;
  const _Step2Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontFamilyFallback: const ['Montserrat Fallback'],
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.outline,
        letterSpacing: 0.9,
      ),
    );
  }
}

/// Outlined text field used in Step 2 (border style, not filled).
class _Step2Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputAction inputAction;

  const _Step2Field({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.inputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textInputAction: inputAction,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontFamilyFallback: const ['Montserrat Fallback'],
        fontSize: 16,
        color: AppColors.onSurface,
        height: 1.5,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 16,
          color: AppColors.outline.withAlpha(160),
          height: 1.5,
        ),
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3 — Choose Gift Cover
// ─────────────────────────────────────────────────────────────────────────────

class _CoverOption {
  final LinearGradient gradient;
  final IconData icon;
  final String label;

  const _CoverOption(
      {required this.gradient, required this.icon, required this.label});
}

const _kCovers = <_CoverOption>[
  _CoverOption(
    gradient: LinearGradient(
      colors: [Color(0xFFE2155F), Color(0xFFB80049)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.favorite_rounded,
    label: 'Romance',
  ),
  _CoverOption(
    gradient: LinearGradient(
      colors: [Color(0xFFD4A017), Color(0xFFFCD400)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.star_rounded,
    label: 'Gold Star',
  ),
  _CoverOption(
    gradient: LinearGradient(
      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.celebration_rounded,
    label: 'Birthday',
  ),
  _CoverOption(
    gradient: LinearGradient(
      colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.local_florist_rounded,
    label: 'Nature',
  ),
  _CoverOption(
    gradient: LinearGradient(
      colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.redeem_rounded,
    label: 'Surprise',
  ),
  _CoverOption(
    gradient: LinearGradient(
      colors: [Color(0xFF00838F), Color(0xFF4DD0E1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.emoji_events_rounded,
    label: 'Achievement',
  ),
];

class _Step3Cover extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _Step3Cover({required this.selectedIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    // covers + 1 upload tile at the end
    final itemCount = _kCovers.length + 1;

    return _EnvelopeCard(
      icon: Icons.image_rounded,
      heading: 'Choose Gift Cover',
      iconOnPrimary: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GIFT COVER IMAGE',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: itemCount,
            itemBuilder: (context, i) {
              // ── Upload tile (last item) ──────────────────────────────────
              if (i == _kCovers.length) {
                return GestureDetector(
                  onTap: () {/* TODO: image picker */},
                  child: _DashedBox(
                    borderRadius: 12,
                    color: AppColors.outlineVariant,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_rounded,
                            color: AppColors.secondaryContainer,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upload',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: const ['Montserrat Fallback'],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // ── Cover tile ───────────────────────────────────────────────
              final cover = _kCovers[i];
              final sel = i == selectedIndex;

              return GestureDetector(
                onTap: () => onSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: cover.gradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sel ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: sel
                        ? const [
                            BoxShadow(
                              color: Color(0x33B80049),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(cover.icon, color: Colors.white, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              cover.label,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (sel)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                              size: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashed border box — drawn with CustomPainter (Border.all has no dash support)
// ─────────────────────────────────────────────────────────────────────────────

class _DashedBox extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color color;

  const _DashedBox({
    required this.child,
    required this.borderRadius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(
        color: color,
        radius: borderRadius,
        dashWidth: 6,
        dashSpace: 4,
        strokeWidth: 1.5,
      ),
      child: child,
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const _DashedRectPainter({
    required this.color,
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        final end = (dist + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(dist, end), paint);
        dist += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRectPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.dashWidth != dashWidth ||
      old.dashSpace != dashSpace ||
      old.strokeWidth != strokeWidth;
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 4 — Add Background Music
// ─────────────────────────────────────────────────────────────────────────────

class _Step4Music extends StatelessWidget {
  final TextEditingController musicCtrl;

  const _Step4Music({required this.musicCtrl});

  @override
  Widget build(BuildContext context) {
    return _EnvelopeCard(
      icon: Icons.music_note_outlined,
      heading: 'Add Background Music',
      iconOnPrimary: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BACKGROUND TRACK',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 8),
          AppSearchField(
            controller: musicCtrl,
            hintText: 'Search for a song or artist',
            textInputAction: TextInputAction.search,
          ),
          const SizedBox(height: 8),
          Text(
            'Type at least 2 characters to find music.',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 13,
              color: AppColors.outline,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 5 — Amount + fee breakdown
// ─────────────────────────────────────────────────────────────────────────────

class _Step5Amount extends StatelessWidget {
  final bool isSingle;
  final TextEditingController amountCtrl;
  final TextEditingController claimsCtrl;
  // Bulk-only
  final TextEditingController totalAmountCtrl;
  final TextEditingController amountPerPersonCtrl;
  final bool batchClaims;
  final ValueChanged<bool> onBatchClaimsChanged;
  final VoidCallback onChanged;

  const _Step5Amount({
    required this.isSingle,
    required this.amountCtrl,
    required this.claimsCtrl,
    required this.totalAmountCtrl,
    required this.amountPerPersonCtrl,
    required this.batchClaims,
    required this.onBatchClaimsChanged,
    required this.onChanged,
  });

  // ── Single helpers ─────────────────────────────────────────────────────────

  String get _singleChipText {
    final amount = double.tryParse(amountCtrl.text) ?? 0;
    return 'One recipient can claim ₦${_fmt(amount)}';
  }

  // ── Bulk helpers ───────────────────────────────────────────────────────────

  int get _claimCount {
    final total = double.tryParse(totalAmountCtrl.text) ?? 0;
    final per = double.tryParse(amountPerPersonCtrl.text) ?? 0;
    if (per <= 0) return 0;
    return (total / per).floor();
  }

  double get _amountPerPerson =>
      double.tryParse(amountPerPersonCtrl.text) ?? 0;

  @override
  Widget build(BuildContext context) =>
      isSingle ? _buildSingle() : _buildBulk();

  // ── Single layout (unchanged) ──────────────────────────────────────────────

  Widget _buildSingle() {
    return _EnvelopeCard(
      icon: Icons.redeem_rounded,
      heading: 'Airtime Amount',
      iconBackgroundColor: AppColors.onPrimaryFixedVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AIRTIME AMOUNT',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.outline,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 8),
          _AmountField(controller: amountCtrl, onChanged: onChanged),
          const SizedBox(height: 6),
          Text(
            'The amount your recipient can claim.',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 13,
              color: AppColors.outline,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withAlpha(77),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _singleChipText,
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
          ),
        ],
      ),
    );
  }

  // ── Bulk layout (new design from Stitch HTML) ──────────────────────────────

  Widget _buildBulk() {
    final n = _claimCount;
    final per = _amountPerPerson;

    return _EnvelopeCard(
      icon: Icons.groups_outlined,
      heading: 'Bulk Airtime Pool',
      iconOnPrimary: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Two side-by-side amount inputs ─────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOTAL POOL AMOUNT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL POOL AMOUNT',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _BulkAmountField(
                      controller: totalAmountCtrl,
                      onChanged: onChanged,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'The total amount you want to distribute.',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 11,
                        color: AppColors.outline,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // AMOUNT PER PERSON
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AMOUNT PER PERSON',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _BulkAmountField(
                      controller: amountPerPersonCtrl,
                      onChanged: onChanged,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Individual claim amount. Result: $n people.',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 11,
                        color: AppColors.outline,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Success alert chip ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withAlpha(77),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green.shade600,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$n ${n == 1 ? 'person' : 'people'} can claim ₦${_fmt(per)} each',
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
          ),

          const SizedBox(height: 20),

          const Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.surfaceVariant,
          ),

          const SizedBox(height: 16),

          // ── Enable Batch Claims toggle ─────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enable Batch Claims',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Allow users to claim for their family members',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: batchClaims,
                onChanged: onBatchClaimsChanged,
                activeColor: AppColors.primary,
                activeTrackColor: AppColors.primaryFixed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action bar — Back (outlined) + Continue / Pay (filled)
// ─────────────────────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  final int step;
  final bool isLoading;
  final double poolTotal;
  final double platformFee;
  final double grandTotal;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const _ActionBar({
    required this.step,
    required this.isLoading,
    required this.poolTotal,
    required this.platformFee,
    required this.grandTotal,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return step == 4
        ? _buildPayFooter(context)
        : _buildNavBar(context);
  }

  // ── Steps 0-3: side-by-side Back / Continue ──────────────────────────────
  Widget _buildNavBar(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottom + 12),
      child: Row(
        children: [
          if (step > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onBack,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.outlineVariant),
                  foregroundColor: AppColors.onSurface,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: step == 0 ? 1 : 1,
            child: FilledButton(
              onPressed: isLoading ? null : onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
                disabledBackgroundColor: AppColors.primaryFixed,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Continue',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 4 (last): Back + fee breakdown card + Pay button ────────────────
  Widget _buildPayFooter(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 30,
            offset: Offset(0, -8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Back button — full width, outline-variant border
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isLoading ? null : onBack,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.outlineVariant),
                foregroundColor: AppColors.onSurface,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Back',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // ── Fee breakdown card ────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceVariant),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _FeeRow(label: 'Airtime Pool', amount: poolTotal),
                const SizedBox(height: 12),
                _FeeRow(
                  label: 'Platform Fee (1.5% above ₦500)',
                  amount: platformFee,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.outlineVariant.withAlpha(100),
                  ),
                ),
                _FeeRow(
                  label: 'Total',
                  amount: grandTotal,
                  isBold: true,
                  isPrimary: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ── Authenticate and Pay button ───────────────────────────────
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading ? null : onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: AppColors.primaryFixed,
                shadowColor: const Color(0x4DB80049),
                elevation: 4,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          const TextSpan(text: 'Authenticate and Pay  '),
                          const TextSpan(
                            text: '₦',
                            style: TextStyle(fontFamily: 'Roboto'),
                          ),
                          TextSpan(text: _fmt(grandTotal)),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared input widgets
// ─────────────────────────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputAction inputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const _Field({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.inputAction = TextInputAction.next,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textInputAction: inputAction,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 14, color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 14,
          color: AppColors.onSurfaceVariant.withAlpha(153),
        ),
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _AmountField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      onChanged: (_) => onChanged(),
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontFamilyFallback: const ['Montserrat Fallback'],
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        letterSpacing: -0.5,
      ),
      decoration: InputDecoration(
        prefix: const Text(
          '₦  ',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
            letterSpacing: -0.5,
          ),
        ),
        hintText: '0',
        hintStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.outline.withAlpha(120),
          letterSpacing: -0.5,
        ),
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Compact amount field — used side-by-side in the bulk Step 5 layout
// ─────────────────────────────────────────────────────────────────────────────

class _BulkAmountField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _BulkAmountField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (_) => onChanged(),
      textInputAction: TextInputAction.next,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontFamilyFallback: const ['Montserrat Fallback'],
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        prefix: const Text(
          '₦ ',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        hintText: '0',
        hintStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.outline.withAlpha(120),
        ),
        filled: false,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fee row
// ─────────────────────────────────────────────────────────────────────────────

class _FeeRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;
  final bool isPrimary;

  const _FeeRow({
    required this.label,
    required this.amount,
    this.isBold = false,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPrimary
        ? AppColors.primary
        : (isBold ? AppColors.onSurface : AppColors.onSurfaceVariant);
    final style = TextStyle(
      fontFamily: 'Montserrat',
      fontFamilyFallback: const ['Montserrat Fallback'],
      fontSize: isBold ? 16 : 14,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
      color: color,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: style)),
        Text.rich(
          TextSpan(
            style: style,
            children: [
              const TextSpan(
                text: '₦',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              TextSpan(text: _fmt(amount)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

TextStyle _label() => const TextStyle(
      fontFamily: 'Montserrat',
      fontFamilyFallback: ['Montserrat Fallback'],
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurfaceVariant,
    );

/// Formats a double as a comma-separated NGN amount string (no ₦ prefix).
String _fmt(double amount) {
  if (amount <= 0) return '0.00';
  final fixed = amount.toStringAsFixed(2);
  final parts = fixed.split('.');
  final buf = StringBuffer();
  final intPart = parts[0];
  for (var i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(',');
    buf.write(intPart[i]);
  }
  return '${buf.toString()}.${parts[1]}';
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_search_field.dart';

/// Money Package gift creation wizard — 4 steps:
/// 1 Message | 2 Cover | 3 Music | 4 Monetary Gift
class MoneyPackagePage extends StatefulWidget {
  const MoneyPackagePage({super.key});

  @override
  State<MoneyPackagePage> createState() => _MoneyPackagePageState();
}

class _MoneyPackagePageState extends State<MoneyPackagePage> {
  int _step = 0;

  // Step 1 — Message
  final _recipientCtrl = TextEditingController();
  final _messageCtrl = TextEditingController(
    text:
        "Sending you some airtime love for those long catch-up calls! Can't wait to hear from you soon. Enjoy the data and talk time! 💝",
  );

  // Step 2 — Photo Gallery
  final List<XFile> _photos = [];

  // Step 3 — Music
  final _musicCtrl = TextEditingController();

  // Step 4 — Monetary Gift
  final _amountCtrl = TextEditingController();
  bool _anonymous = false;

  static const _kStepLabels = ['Message', 'Cover', 'Music', 'Gift'];

  @override
  void dispose() {
    _recipientCtrl.dispose();
    _messageCtrl.dispose();
    _musicCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  void _submit() {
    // TODO: dispatch GiftCreationBloc event for money package
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _MoneyHeader(onBack: () => context.pop()),
          _MoneyProgressBar(step: _step, labels: _kStepLabels),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: _buildStep(),
            ),
          ),
          _MoneyActionBar(step: _step, onBack: _back, onContinue: _next),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _Step2Message(
          recipientCtrl: _recipientCtrl,
          messageCtrl: _messageCtrl,
        );
      case 1:
        return _Step3PhotoGallery(
          photos: _photos,
          onPhotosChanged: (updated) => setState(() {
            _photos
              ..clear()
              ..addAll(updated);
          }),
        );
      case 2:
        return _Step4Music(musicCtrl: _musicCtrl);
      case 3:
        return _Step5Gift(
          amountCtrl: _amountCtrl,
          anonymous: _anonymous,
          onAnonymousChanged: (v) => setState(() => _anonymous = v),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _MoneyHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _MoneyHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceVariant, width: 0.5),
        ),
      ),
      padding: EdgeInsets.only(
          top: top + 4, left: 4, right: 20, bottom: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            color: AppColors.onSurfaceVariant,
          ),
          const Icon(
            Icons.card_giftcard_rounded,
            color: AppColors.primary,
            size: 26,
          ),
          const SizedBox(width: 8),
          Text(
            'Money package',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step progress bar
// ─────────────────────────────────────────────────────────────────────────────

class _MoneyProgressBar extends StatelessWidget {
  final int step;
  final List<String> labels;

  const _MoneyProgressBar({required this.step, required this.labels});

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
                'Step ${step + 1} of ${labels.length}',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14, color: AppColors.onSurfaceVariant),
              ),
              Text(
                labels[step],
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              labels.length,
              (i) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  margin: EdgeInsets.only(right: i < labels.length - 1 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: i <= step
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

class _MoneyCard extends StatelessWidget {
  final IconData icon;
  final String heading;
  final Widget child;
  final bool showDivider;
  /// When true: show an "Optional" badge beside the heading row
  final bool optional;

  const _MoneyCard({
    required this.icon,
    required this.heading,
    required this.child,
    this.showDivider = false,
    this.optional = false,
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
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33B80049),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: AppColors.onPrimary, size: 22),
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
              if (optional)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Optional',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
            ],
          ),
          if (showDivider) ...[
            const SizedBox(height: 16),
            const Divider(
                height: 1, thickness: 0.5, color: AppColors.surfaceVariant),
          ],
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label — uppercase tracking-wider (used across all steps)
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontFamilyFallback: const ['Montserrat Fallback'],
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.outline,
        letterSpacing: 0.9,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Outlined text field — body-lg 18px (Steps 2 & 4)
// ─────────────────────────────────────────────────────────────────────────────

class _OutlinedField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputAction inputAction;

  const _OutlinedField({
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
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Montserrat Fallback'],
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 28 / 18,
          color: AppColors.outline.withAlpha(160),
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
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — Personalize Gift (recipient name + message textarea)
// ─────────────────────────────────────────────────────────────────────────────

class _Step2Message extends StatelessWidget {
  final TextEditingController recipientCtrl;
  final TextEditingController messageCtrl;

  const _Step2Message({
    required this.recipientCtrl,
    required this.messageCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return _MoneyCard(
      icon: Icons.edit_outlined,
      heading: 'Personalize Gift',
      showDivider: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Recipient Name'),
          const SizedBox(height: 8),
          _OutlinedField(
            controller: recipientCtrl,
            hint: 'Who is this gift for?',
            inputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          _SectionLabel('Your Message'),
          const SizedBox(height: 8),
          _OutlinedField(
            controller: messageCtrl,
            hint: 'Write a heartfelt message...',
            maxLines: 4,
            inputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3 — Photo Gallery (pick up to 4 photos from device)
// ─────────────────────────────────────────────────────────────────────────────

class _Step3PhotoGallery extends StatefulWidget {
  final List<XFile> photos;
  final ValueChanged<List<XFile>> onPhotosChanged;

  const _Step3PhotoGallery({
    required this.photos,
    required this.onPhotosChanged,
  });

  @override
  State<_Step3PhotoGallery> createState() => _Step3PhotoGalleryState();
}

class _Step3PhotoGalleryState extends State<_Step3PhotoGallery> {
  static const _kMaxPhotos = 4;
  final _picker = ImagePicker();

  Future<void> _pickPhotos() async {
    final remaining = _kMaxPhotos - widget.photos.length;
    if (remaining <= 0) return;

    final picked = await _picker.pickMultiImage(limit: remaining);
    if (picked.isEmpty) return;

    final updated = [...widget.photos, ...picked];
    widget.onPhotosChanged(
      updated.length > _kMaxPhotos ? updated.sublist(0, _kMaxPhotos) : updated,
    );
  }

  void _removePhoto(int index) {
    final updated = [...widget.photos]..removeAt(index);
    widget.onPhotosChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.photos.length;
    final canAdd = count < _kMaxPhotos;

    return _MoneyCard(
      icon: Icons.image_rounded,
      heading: 'Choose Gift Cover',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: label + count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Photo Gallery',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '$count / $_kMaxPhotos photos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: count == _kMaxPhotos
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Photo grid: selected thumbnails + add button
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Existing photos
              for (var i = 0; i < widget.photos.length; i++)
                _PhotoThumb(
                  file: widget.photos[i],
                  onRemove: () => _removePhoto(i),
                ),
              // Add button — only shown when under limit
              if (canAdd)
                GestureDetector(
                  onTap: _pickPhotos,
                  child: _DashedUploadBox(),
                ),
            ],
          ),

          if (count == _kMaxPhotos) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  'All $_kMaxPhotos photos selected',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A selected photo thumbnail with a remove button in the top-right corner.
class _PhotoThumb extends StatelessWidget {
  final XFile file;
  final VoidCallback onRemove;

  const _PhotoThumb({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(file.path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 128×128 dashed-border add-photo button.
class _DashedUploadBox extends StatelessWidget {
  const _DashedUploadBox();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: CustomPaint(
        painter: _DashedRectPainter(
          color: AppColors.outlineVariant,
          radius: 12,
          dashWidth: 6,
          dashSpace: 4,
          strokeWidth: 1.5,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.onSurfaceVariant,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'ADD PHOTO',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 4 — Add Background Music (search field only — no tracks, no AI)
// ─────────────────────────────────────────────────────────────────────────────

class _Step4Music extends StatelessWidget {
  final TextEditingController musicCtrl;

  const _Step4Music({required this.musicCtrl});

  @override
  Widget build(BuildContext context) {
    return _MoneyCard(
      icon: Icons.music_note_outlined,
      heading: 'Add Background Music',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Background Track'),
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
                fontSize: 13, color: AppColors.outline, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 5 — Add Monetary Gift
// ─────────────────────────────────────────────────────────────────────────────

class _Step5Gift extends StatelessWidget {
  final TextEditingController amountCtrl;
  final bool anonymous;
  final ValueChanged<bool> onAnonymousChanged;

  const _Step5Gift({
    required this.amountCtrl,
    required this.anonymous,
    required this.onAnonymousChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Envelope card: description + amount field + wallet chip ──
        _MoneyCard(
          icon: Icons.monetization_on_outlined,
          heading: 'Add Monetary Gift',
          optional: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Surprise them with extra cash in their digital wallet!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Amount label + ₦ field
              _SectionLabel('Amount (NGN)'),
              const SizedBox(height: 8),
              TextField(
                controller: amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: AppColors.outline.withAlpha(120),
                  ),
                  prefix: const Text(
                    '₦  ',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.outlineVariant, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),

              const SizedBox(height: 20),

              // Wallet Balance chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                      color: AppColors.outlineVariant.withAlpha(51)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💰', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                        children: const [
                          TextSpan(text: 'Wallet Balance: '),
                          TextSpan(
                            text: '₦',
                            style: TextStyle(fontFamily: 'Roboto'),
                          ),
                          TextSpan(text: '0'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── Send anonymously (outside card) ──
        GestureDetector(
          onTap: () => onAnonymousChanged(!anonymous),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: anonymous
                      ? AppColors.primary
                      : AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color:
                        anonymous ? AppColors.primary : AppColors.outline,
                    width: 2,
                  ),
                ),
                child: anonymous
                    ? const Icon(Icons.check_rounded,
                        color: AppColors.onPrimary, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                'Send anonymously',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 16,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Divider(color: AppColors.outlineVariant, height: 1),
        const SizedBox(height: 20),

        // ── Live Preview row (outside card) ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LIVE PREVIEW',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.9,
              ),
            ),
            Row(
              children: [
                _PreviewToggleBtn(
                  icon: Icons.smartphone_rounded,
                  selected: true,
                ),
                const SizedBox(width: 8),
                _PreviewToggleBtn(
                  icon: Icons.desktop_windows_rounded,
                  selected: false,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PreviewToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const _PreviewToggleBtn({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.surfaceContainerHigh
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: 18,
        color:
            selected ? AppColors.onSurface : AppColors.onSurfaceVariant,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action bar — steps 0–2: Back + Continue pill buttons
//              step 4:    PROCEED TO REVIEW GIFT + SAVE AS DRAFT
// ─────────────────────────────────────────────────────────────────────────────

class _MoneyActionBar extends StatelessWidget {
  final int step;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const _MoneyActionBar({
    required this.step,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return step == 3
        ? _buildFinalBar(context, bottom)
        : _buildNavBar(context, bottom);
  }

  Widget _buildNavBar(BuildContext context, double bottom) {
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
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: AppColors.outlineVariant, width: 2),
                  foregroundColor: AppColors.onSurface,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontFamilyFallback: const ['Montserrat Fallback'],
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: FilledButton(
              onPressed: onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalBar(BuildContext context, double bottom) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // PROCEED TO REVIEW GIFT — primary full-width
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shadowColor: const Color(0x4DB80049),
                elevation: 6,
              ),
              child: Text(
                'PROCEED TO REVIEW GIFT',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // SAVE AS DRAFT — text button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.onSurfaceVariant,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(
                'SAVE AS DRAFT',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
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
// Dashed border box — CustomPainter (no dash support in Border.all)
// ─────────────────────────────────────────────────────────────────────────────

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

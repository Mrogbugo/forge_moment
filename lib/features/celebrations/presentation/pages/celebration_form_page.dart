import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Colour constants ──────────────────────────────────────────────────────────
const _kPrimary = Color(0xFFBA0037);
const _kOnPrimary = Color(0xFFFFFFFF);
const _kPrimaryFixed = Color(0xFFFFDADB);
const _kSurface = Color(0xFFFCF9F8);
const _kSurfaceLowest = Color(0xFFFFFFFF);
const _kSurfaceLow = Color(0xFFF6F3F2);
const _kOnSurface = Color(0xFF1C1B1B);
const _kOnSurfaceVariant = Color(0xFF5B4041);
const _kSecondary = Color(0xFF685D4A);
const _kSecondaryFixed = Color(0xFFF0E0C8);
const _kOnSecondaryFixed = Color(0xFF221B0B);
const _kSecondaryContainer = Color(0xFFEDDEC5);

class CelebrationFormPage extends StatefulWidget {
  final dynamic existing;
  const CelebrationFormPage({super.key, this.existing});

  @override
  State<CelebrationFormPage> createState() => _CelebrationFormPageState();
}

class _CelebrationFormPageState extends State<CelebrationFormPage> {
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  bool _nameFocused = false;

  String _selectedOccasion = '🎂 Birthday';
  DateTime? _selectedDate;
  bool _recurring = true;
  int _cadenceIndex = 1;
  bool _autoDraft = true;
  bool _saving = false;
  bool _saved = false;

  static const _occasions = [
    '🎂 Birthday',
    '💎 Anniversary',
    '🏆 Promotion',
    '🎓 Graduation',
    '🏡 Housewarming',
    '✨ Custom Moment',
  ];

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      setState(() => _nameFocused = _nameFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() {
      _saving = true;
      _saved = false;
    });
    await Future.delayed(const Duration(milliseconds: 750));
    if (!mounted) return;
    setState(() {
      _saving = false;
      _saved = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    context.pop();
  }

  String get _dateDisplay {
    if (_selectedDate == null) return 'Select a date';
    final d = _selectedDate!;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

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
          'Add Celebration',
          style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _kOnSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroBanner(),
            const SizedBox(height: 20),
            _buildWhoSection(),
            const SizedBox(height: 16),
            _buildOccasionSection(),
            const SizedBox(height: 16),
            _buildCadenceSection(),
            const SizedBox(height: 16),
            _buildTrustCard(),
            const SizedBox(height: 24),
            _buildSaveButton(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified_user,
                  size: 16,
                  color: _kOnSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Synced with Forge AI Concierge Assistant',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: _kOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kPrimaryFixed, _kSurfaceLow, _kSecondaryContainer],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _kSurfaceLowest,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _kPrimary.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome, size: 24, color: _kPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Never Miss What Matters',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _kOnSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a celebration and Forge AI will remind you in advance with bespoke gift ideas.',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _kOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, size: 20, color: _kPrimary),
              const SizedBox(width: 8),
              Text(
                'Who are we celebrating?',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _kOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Recipient Name',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _kOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 15,
              color: _kOnSurface,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: _kSurfaceLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              hintText: 'e.g., Sarah Afolayan',
              hintStyle: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: _kOnSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccasionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.celebration, size: 20, color: _kPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Occasion & Event',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _kOnSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _kSecondaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Curated',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _kOnSecondaryFixed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Select Celebration Type',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _kOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: _kSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.cake, color: _kPrimary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedOccasion,
                      isExpanded: true,
                      icon: const SizedBox.shrink(),
                      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 14,
                        color: _kOnSurface,
                      ),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedOccasion = v);
                      },
                      items: _occasions
                          .map(
                            (o) => DropdownMenuItem(
                              value: o,
                              child: Text(o),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const Icon(Icons.expand_more, color: _kOnSurfaceVariant),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Celebration Date',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _kOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: _kSurfaceLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: _kPrimary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _dateDisplay,
                      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 16,
                        fontWeight: _selectedDate != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _selectedDate != null
                            ? _kOnSurface
                            : _kOnSurfaceVariant,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.edit_calendar,
                    color: _kOnSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _kSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Annually Recurring',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _kOnSurface,
                        ),
                      ),
                      Text(
                        'Sync yearly so you never lose track',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: _kOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _recurring,
                  activeThumbColor: _kPrimary,
                  activeTrackColor: _kPrimary.withValues(alpha: 0.5),
                  onChanged: (v) => setState(() => _recurring = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCadenceSection() {
    const cadences = [
      _CadenceData('14 Days Prior', 'Best for custom orders', false),
      _CadenceData('7 Days Prior', 'Recommended window', true),
      _CadenceData('3 Days Prior', 'Express courier cutoff', false),
      _CadenceData('Day of Event', 'Instant digital voucher', false),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active,
                size: 20,
                color: _kPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                'Reminder Cadence',
                style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _kOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'When would you like to be alerted?',
            style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: _kOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(cadences.length, (i) {
              final c = cadences[i];
              final isSelected = _cadenceIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _cadenceIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? _kPrimaryFixed : _kSurfaceLow,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(
                            color: _kPrimary.withValues(alpha: 0.2),
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: _kPrimary.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.title,
                              style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? _kPrimary : _kOnSurface,
                              ),
                            ),
                          ),
                          if (c.hasStar)
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: _kPrimary,
                            ),
                        ],
                      ),
                      Text(
                        c.sub,
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: _kOnSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_fix_high,
                      size: 20,
                      color: _kSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Auto-Draft Bespoke Hamper',
                        style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _kOnSurface,
                        ),
                      ),
                    ),
                    Switch(
                      value: _autoDraft,
                      activeThumbColor: _kPrimary,
                      activeTrackColor: _kPrimary.withValues(alpha: 0.5),
                      onChanged: (v) => setState(() => _autoDraft = v),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Forge AI will automatically draft a curated gift proposal based on the recipient\'s profile and occasion.',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _kOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kSecondaryFixed.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: _kSecondaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock, size: 18, color: _kOnSecondaryFixed),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your data is private & secure',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kOnSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Celebration details are encrypted and never shared with third parties.',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: _kOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPrimary,
        foregroundColor: _kOnPrimary,
        minimumSize: const Size(double.infinity, 56),
        shape: const StadiumBorder(),
        elevation: 4,
        shadowColor: _kPrimary.withValues(alpha: 0.25),
      ),
      onPressed: (_saving || _saved) ? null : _handleSave,
      child: _saving
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Securing Celebration...',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : _saved
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Celebration Saved!',
                      style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Save Celebration',
                  style: TextStyle(fontFamily: 'Montserrat', fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
    );
  }
}

// ── Data helper ───────────────────────────────────────────────────────────────

class _CadenceData {
  final String title;
  final String sub;
  final bool hasStar;
  const _CadenceData(this.title, this.sub, this.hasStar);
}

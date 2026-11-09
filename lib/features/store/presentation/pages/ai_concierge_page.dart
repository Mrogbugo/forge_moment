import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

// ---------------------------------------------------------------------------
// Static conversation data
// ---------------------------------------------------------------------------

const _occasionOptions = ['Anniversary', 'Birthday', 'Wedding', 'Just Because'];
const _recipientOptions = ['My Partner', 'Parents', 'Friends'];

class _GiftRecommendation {
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final bool isTopPick;

  const _GiftRecommendation({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isTopPick = false,
  });
}

const _recommendations = [
  _GiftRecommendation(
    name: 'The Golden Hour Collection',
    description:
        'A curated selection of artisanal champagne truffles and a custom engraved keepsake.',
    price: '₦125,000',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAeKXQP4-IFWBnPURJja3aQib09wTKYW7ibYrYtS5vPl1bTUvEY_zwp5dpBZRdeeZlqQQ5xsEpjNn0u23g9HePG20Owq7sxqhE_Um9jrahMj5ZF7cN7NcM4EeisZFLiTr6TpYsmg2s6p_93uAEjZNx9tsGS5EI1Yj88LX7moaNFKNAuZjSGsXtSFcAf5Fbjt9YxaOsOrWYe8uAZwInBd8t2LvgtIWApM2hsCPX1Ge35cO8EP1oG8WyVeQ',
    isTopPick: true,
  ),
  _GiftRecommendation(
    name: 'Eternal Bloom Arrangement',
    description:
        'Preserved roses that last a year, presented in a minimal glass vessel.',
    price: '₦85,000',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAUuuAX1HS1vJ8-JrUSfo-8S_fgkmRqdT_FqkqDoa5ohVI-CyORRwpQTZaow_JAvUia-N1wbdZA_FT9gLk6FiAwHO-F-8mg_cO95MWuXMQukgku3Mtg_3f67rXB4t-KhEyiE9IToBa2oJ1feM89kqPz0ik-USTxCLNqMRFIZYfeKhw9eIKQZ915pq3nkcYnmLcdMWQhHuHe2N2ARL0pUuy9uhpsB5u6UFMbHSGCA0e9a1eHeZIjRvVc7A',
  ),
];

// ---------------------------------------------------------------------------
// AiConciergePage
// ---------------------------------------------------------------------------

class AiConciergePage extends StatefulWidget {
  const AiConciergePage({super.key});

  @override
  State<AiConciergePage> createState() => _AiConciergePageState();
}

class _AiConciergePageState extends State<AiConciergePage> {
  String? _selectedOccasion;
  String? _selectedRecipient;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final has = _textController.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  void _onOccasionSelected(String occasion) {
    setState(() => _selectedOccasion = occasion);
    _scrollToBottom();
  }

  void _onRecipientSelected(String recipient) {
    setState(() => _selectedRecipient = recipient);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              children: [
                _buildWelcomeBanner(),
                const SizedBox(height: 20),

                // AI message 1: What are you celebrating?
                _buildAiBubble(
                  'Hello! I\'m your Forge Moments concierge. To craft the perfect gift, tell me — '
                  'what are you celebrating?',
                  optionRow: _selectedOccasion == null
                      ? _buildOptionRow(
                          _occasionOptions, _onOccasionSelected)
                      : null,
                ),
                const SizedBox(height: 12),

                // User reply 1
                if (_selectedOccasion != null) ...[
                  _buildUserBubble(_selectedOccasion!),
                  const SizedBox(height: 12),

                  // AI message 2: Who are you gifting?
                  _buildAiBubble(
                    'A wonderful milestone. Who are you gifting this to?',
                    optionRow: _selectedRecipient == null
                        ? _buildOptionRow(
                            _recipientOptions, _onRecipientSelected)
                        : null,
                  ),
                  const SizedBox(height: 12),
                ],

                // User reply 2
                if (_selectedRecipient != null) ...[
                  _buildUserBubble(_selectedRecipient!),
                  const SizedBox(height: 12),

                  // AI message 3: Curated recommendations
                  _buildAiBubble(
                    'Lovely. Based on a ${_selectedOccasion!.toLowerCase()} for your '
                    '${_selectedRecipient!.toLowerCase()}, here are curated suggestions '
                    'that balance elegance and sentiment.',
                    bottomContent: _buildRecommendations(context),
                  ),
                  const SizedBox(height: 12),
                ],

                SizedBox(height: bottomPad + 80),
              ],
            ),
          ),
          _buildInputArea(context, bottomPad),
        ],
      ),
    );
  }

  // ── App bar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 20),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.of(context).padding.top + 8,
              16,
              8,
            ),
            decoration: const BoxDecoration(
              color: Color(0xB3F9F9F9),
              border: Border(
                bottom: BorderSide(color: Color(0x14000000), width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Back button
                Container(
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
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'AI Gift Concierge',
                      style: AppTextStyles.headlineMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Personalised gift discovery',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // AI avatar
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Welcome banner ──────────────────────────────────────────────────────────

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The AI Gift Concierge',
            style: AppTextStyles.headlineMd.copyWith(
              color: AppColors.onSurface,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Let me help you find the perfect expression of appreciation. '
            'Answer a few simple questions.',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Montserrat Fallback'],
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── AI chat bubble ──────────────────────────────────────────────────────────

  Widget _buildAiBubble(
    String message, {
    Widget? optionRow,
    Widget? bottomContent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Avatar
        Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.only(right: 10, bottom: 2),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: const Icon(Icons.auto_awesome, size: 16, color: AppColors.secondary),
        ),
        // Bubble
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.outlineVariant.withAlpha(100)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06B80049),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 14,
                    color: AppColors.onSurface,
                    height: 1.5,
                  ),
                ),
                if (optionRow != null) ...[
                  const SizedBox(height: 14),
                  optionRow,
                ],
                if (bottomContent != null) ...[
                  const SizedBox(height: 16),
                  bottomContent,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── User chat bubble ────────────────────────────────────────────────────────

  Widget _buildUserBubble(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26B80049),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: const ['Montserrat Fallback'],
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Option pills row ────────────────────────────────────────────────────────

  Widget _buildOptionRow(List<String> options, void Function(String) onSelect) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        return GestureDetector(
          onTap: () => onSelect(opt),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: const ['Montserrat Fallback'],
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
                letterSpacing: 0.05,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Recommendation cards ────────────────────────────────────────────────────

  Widget _buildRecommendations(BuildContext context) {
    return Column(
      children: _recommendations.map((rec) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _RecommendationCard(rec: rec),
        );
      }).toList(),
    );
  }

  // ── Input area — WhatsApp style ─────────────────────────────────────────────

  Widget _buildInputArea(BuildContext context, double bottomPad) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 8, 10, bottomPad + 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F2F5), // WhatsApp's light grey bar
        border: Border(
          top: BorderSide(color: Color(0x14000000), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Pill text field ──────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Emoji icon
                  Padding(
                    padding: const EdgeInsets.only(left: 14, bottom: 13),
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      size: 26,
                      color: AppColors.onSurfaceVariant.withAlpha(180),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Auto-growing text field
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 15,
                        color: AppColors.onSurface,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a custom response…',
                        hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 15,
                          color: AppColors.onSurfaceVariant.withAlpha(140),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ── Send / Mic button ────────────────────────────────────────────
          GestureDetector(
            onTap: _hasText ? () {
              // TODO: send message
              _textController.clear();
            } : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33B80049),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                _hasText ? Icons.send_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _RecommendationCard
// ---------------------------------------------------------------------------

class _RecommendationCard extends StatelessWidget {
  final _GiftRecommendation rec;

  const _RecommendationCard({required this.rec});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: rec.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 150,
                  color: AppColors.surfaceContainerLow,
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD9DE), Color(0xFFE2155F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              if (rec.isTopPick)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withAlpha(220),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'Highly Recommended',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Montserrat Fallback'],
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSecondaryFixed,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.name,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rec.description,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontFamilyFallback: const ['Montserrat Fallback'],
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                        children: [
                          const TextSpan(
                            text: '₦',
                            style: TextStyle(fontFamily: 'Roboto'),
                          ),
                          TextSpan(text: rec.price.replaceFirst('₦', '')),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        'Add to Moment',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontFamilyFallback: const ['Montserrat Fallback'],
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

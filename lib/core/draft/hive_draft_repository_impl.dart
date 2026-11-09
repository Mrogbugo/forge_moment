import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'draft_repository.dart';

/// Hive-backed local draft repository.
///
/// Stores drafts as JSON strings keyed by userId so data never leaks
/// between accounts on a shared device (FR-11.2).
/// No TypeAdapter required — serialises [GiftDraftLocal] to/from JSON manually.
class HiveDraftRepositoryImpl implements DraftRepository {
  static const String _boxName = 'gift_drafts';
  late final Box<String> _box;

  /// Call once during DI setup, after [Hive.initFlutter].
  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  @override
  Future<GiftDraftLocal?> loadGiftDraft(String userId) async {
    final raw = _box.get(userId);
    if (raw == null) return null;
    try {
      return _fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt entry — discard silently
      await _box.delete(userId);
      return null;
    }
  }

  @override
  Future<void> saveGiftDraft(String userId, GiftDraftLocal draft) =>
      _box.put(userId, jsonEncode(_toJson(draft)));

  @override
  Future<void> clearGiftDraft(String userId) => _box.delete(userId);

  Map<String, dynamic> _toJson(GiftDraftLocal d) => {
        'template_id': d.templateId,
        'message': d.message,
        'media_local_paths': d.mediaLocalPaths,
        'music_track_id': d.musicTrackId,
        'monetary_amount': d.monetaryAmount,
        'anonymous': d.anonymous,
        'recipient_name': d.recipientName,
        'recipient_contact': d.recipientContact,
        'delivery_method': d.deliveryMethod,
        'server_draft_id': d.serverDraftId,
        'updated_at': d.updatedAt.toIso8601String(),
      };

  GiftDraftLocal _fromJson(Map<String, dynamic> j) => GiftDraftLocal(
        templateId: j['template_id'] as String?,
        message: j['message'] as String?,
        mediaLocalPaths: List<String>.from(j['media_local_paths'] ?? []),
        musicTrackId: j['music_track_id'] as String?,
        monetaryAmount: (j['monetary_amount'] as num?)?.toDouble(),
        anonymous: j['anonymous'] as bool? ?? false,
        recipientName: j['recipient_name'] as String?,
        recipientContact: j['recipient_contact'] as String?,
        deliveryMethod: j['delivery_method'] as String?,
        serverDraftId: j['server_draft_id'] as String?,
        updatedAt: DateTime.parse(j['updated_at'] as String),
      );
}

// Local encrypted draft repository (FRD Section 11 + FR-GIFT-013)
// Lifecycle:
//   - Autosave after debounce and on app backgrounding
//   - Sync to backend once authenticated and server draft exists
//   - Preserve version/update timestamp to avoid overwriting newer server data
//   - Prompt user when local and server versions materially differ
//   - Remove draft only after success is confirmed
// Namespaced by userId to prevent data leakage on account switch (FR-11.2)
// TODO: use hive / isar / sqflite with encryption
abstract class DraftRepository {
  Future<GiftDraftLocal?> loadGiftDraft(String userId);
  Future<void> saveGiftDraft(String userId, GiftDraftLocal draft);
  Future<void> clearGiftDraft(String userId);
}

class GiftDraftLocal {
  final String? templateId;
  final String? message;
  final List<String> mediaLocalPaths;
  final String? musicTrackId;
  final double? monetaryAmount;
  final bool anonymous;
  final String? recipientName;
  final String? recipientContact;
  final String? deliveryMethod;
  final String? serverDraftId;
  final DateTime updatedAt;

  const GiftDraftLocal({
    this.templateId,
    this.message,
    this.mediaLocalPaths = const [],
    this.musicTrackId,
    this.monetaryAmount,
    this.anonymous = false,
    this.recipientName,
    this.recipientContact,
    this.deliveryMethod,
    this.serverDraftId,
    required this.updatedAt,
  });
}

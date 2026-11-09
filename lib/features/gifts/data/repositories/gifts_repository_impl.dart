import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../../../core/upload/upload_manager.dart';
import '../../../../shared/models/paginated_response.dart';
import '../../domain/entities/gift.dart';
import '../../domain/repositories/gifts_repository.dart';

class GiftsRepositoryImpl implements GiftsRepository {
  final ApiClient _api;
  final UploadManager _uploader;
  GiftsRepositoryImpl({required ApiClient api, required UploadManager uploader})
      : _api = api, _uploader = uploader;

  Gift _parse(Map<String, dynamic> j) => Gift(
        id: j['id'] as String,
        templateId: j['template_id'] as String?,
        message: j['message'] as String?,
        mediaUrls: List<String>.from(j['media_urls'] ?? []),
        musicTrackId: j['music_track_id'] as String?,
        monetaryAmount: (j['monetary_amount'] as num?)?.toDouble(),
        anonymous: j['anonymous'] as bool? ?? false,
        recipientName: j['recipient_name'] as String?,
        recipientContact: j['recipient_contact'] as String?,
        deliveryMethod: j['delivery_method'] != null
            ? DeliveryMethod.values.firstWhere(
                (m) => m.name == j['delivery_method'],
                orElse: () => DeliveryMethod.whatsapp)
            : null,
        status: GiftStatus.values.firstWhere(
            (s) => s.name == (j['status'] as String? ?? 'draft'),
            orElse: () => GiftStatus.draft),
        publicLink: j['public_link'] as String?,
        createdAt: DateTime.parse(j['created_at'] as String),
        sentAt: j['sent_at'] != null ? DateTime.parse(j['sent_at'] as String) : null,
      );

  @override
  Future<List<Map<String, dynamic>>> getTemplates({String? categoryId}) async {
    final res = await _api.get(ApiEndpoints.giftTemplates,
        query: {if (categoryId != null) 'category_id': categoryId});
    return List<Map<String, dynamic>>.from(res['templates'] ?? res['items'] ?? []);
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    final res = await _api.get(ApiEndpoints.storeCategories);
    return List<Map<String, dynamic>>.from(res['categories'] ?? res['items'] ?? []);
  }

  @override
  Future<List<Map<String, dynamic>>> getMusicTracks({String? genre, String? query}) async {
    final res = await _api.get(ApiEndpoints.giftMusic,
        query: {if (genre != null) 'genre': genre, if (query != null) 'q': query});
    return List<Map<String, dynamic>>.from(res['tracks'] ?? res['items'] ?? []);
  }

  @override
  Future<Gift> createDraft(Map<String, dynamic> payload) async {
    final res = await _api.post(ApiEndpoints.gifts, body: payload);
    return _parse(res);
  }

  @override
  Future<Gift> updateDraft(String id, Map<String, dynamic> payload) async {
    final res = await _api.patch('${ApiEndpoints.gifts}/$id', body: payload);
    return _parse(res);
  }

  @override
  Future<void> deleteDraft(String id) =>
      _api.delete('${ApiEndpoints.gifts}/$id');

  @override
  Future<String> uploadMedia(String giftId, String localPath,
      {void Function(double)? onProgress}) async {
    final result = await _uploader.uploadImage(
      localPath,
      uploadUrl: '${ApiEndpoints.gifts}/$giftId/media',
      onProgress: onProgress,
    );
    return result.remoteUrl;
  }

  @override
  Future<void> deleteMedia(String giftId, String mediaId) =>
      _api.delete('${ApiEndpoints.gifts}/$giftId/media/$mediaId');

  @override
  Future<Gift> send(String giftId) async {
    final res = await _api.post(
      ApiEndpoints.giftSend.replaceFirst('{id}', giftId),
      idempotencyKey: 'send-$giftId',
    );
    return _parse(res);
  }

  @override
  Future<void> initializePayment(String giftId, String paymentMethod) =>
      _api.post('${ApiEndpoints.gifts}/$giftId/payment',
          body: {'method': paymentMethod},
          idempotencyKey: 'pay-init-$giftId');

  @override
  Future<Gift> verifyPayment(String giftId, String reference) async {
    final res = await _api.post(
      ApiEndpoints.giftPaymentVerify.replaceFirst('{id}', giftId),
      body: {'reference': reference},
    );
    return _parse(res);
  }

  @override
  Future<PaginatedResponse<Map<String, dynamic>>> getSentGifts({int page = 1}) async {
    final res = await _api.get(ApiEndpoints.giftSent, query: {'page': page.toString()});
    return PaginatedResponse.fromJson(res, (j) => j);
  }

  @override
  Future<PaginatedResponse<Map<String, dynamic>>> getReceivedGifts({int page = 1}) async {
    final res = await _api.get(ApiEndpoints.giftReceived, query: {'page': page.toString()});
    return PaginatedResponse.fromJson(res, (j) => j);
  }

  @override
  Future<List<Map<String, dynamic>>> getIdeas() async {
    final res = await _api.get(ApiEndpoints.giftIdeas);
    return List<Map<String, dynamic>>.from(res['ideas'] ?? res['items'] ?? []);
  }
}

import '../../../../shared/models/paginated_response.dart';
import '../entities/gift.dart';

abstract class GiftsRepository {
  Future<List<Map<String, dynamic>>> getTemplates({String? categoryId});
  Future<List<Map<String, dynamic>>> getCategories();
  Future<List<Map<String, dynamic>>> getMusicTracks({String? genre, String? query});
  Future<Gift> createDraft(Map<String, dynamic> payload);
  Future<Gift> updateDraft(String id, Map<String, dynamic> payload);
  Future<void> deleteDraft(String id);
  Future<String> uploadMedia(String giftId, String localPath, {void Function(double)? onProgress});
  Future<void> deleteMedia(String giftId, String mediaId);
  Future<Gift> send(String giftId);
  Future<void> initializePayment(String giftId, String paymentMethod);
  Future<Gift> verifyPayment(String giftId, String reference);
  Future<PaginatedResponse<Map<String, dynamic>>> getSentGifts({int page = 1});
  Future<PaginatedResponse<Map<String, dynamic>>> getReceivedGifts({int page = 1});
  Future<List<Map<String, dynamic>>> getIdeas();
}

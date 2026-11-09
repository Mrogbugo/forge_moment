import '../../../../shared/models/paginated_response.dart';
import '../entities/celebration.dart';

abstract class CelebrationsRepository {
  Future<PaginatedResponse<Celebration>> getCelebrations({int page = 1});
  Future<List<Celebration>> getUpcoming();
  Future<Celebration> addCelebration(Map<String, dynamic> payload);
  Future<Celebration> updateCelebration(String id, Map<String, dynamic> payload);
  Future<void> deleteCelebration(String id);
  Future<Map<String, dynamic>> scheduleGift(String celebrationId, Map<String, dynamic> payload);
}

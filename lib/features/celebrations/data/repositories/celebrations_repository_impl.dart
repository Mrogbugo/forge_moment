import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../../../shared/models/paginated_response.dart';
import '../../domain/entities/celebration.dart';
import '../../domain/repositories/celebrations_repository.dart';

class CelebrationsRepositoryImpl implements CelebrationsRepository {
  final ApiClient _api;
  CelebrationsRepositoryImpl({required ApiClient api}) : _api = api;

  Celebration _parse(Map<String, dynamic> j) => Celebration(
        id: j['id'] as String,
        personName: j['person_name'] as String,
        date: DateTime.parse(j['date'] as String),
        occasion: Occasion.values.firstWhere(
          (o) => o.name == (j['occasion'] as String? ?? 'other'),
          orElse: () => Occasion.other,
        ),
        recurrence: Recurrence.values.firstWhere(
          (r) => r.name == (j['recurrence'] as String? ?? 'annually'),
          orElse: () => Recurrence.annually,
        ),
        relationship: j['relationship'] as String?,
        reminderEnabled: j['reminder_enabled'] as bool? ?? true,
        reminderDaysBefore: j['reminder_days_before'] as int? ?? 3,
      );

  @override
  Future<PaginatedResponse<Celebration>> getCelebrations({int page = 1}) async {
    final res = await _api.get(ApiEndpoints.celebrations, query: {'page': page.toString()});
    return PaginatedResponse.fromJson(res, _parse);
  }

  @override
  Future<List<Celebration>> getUpcoming() async {
    final res = await _api.get(ApiEndpoints.upcomingCelebrations);
    return (res['celebrations'] as List? ?? []).map((c) => _parse(c as Map<String, dynamic>)).toList();
  }

  @override
  Future<Celebration> addCelebration(Map<String, dynamic> payload) async {
    final res = await _api.post(ApiEndpoints.celebrations, body: payload);
    return _parse(res);
  }

  @override
  Future<Celebration> updateCelebration(String id, Map<String, dynamic> payload) async {
    final res = await _api.put('${ApiEndpoints.celebrations}/$id', body: payload);
    return _parse(res);
  }

  @override
  Future<void> deleteCelebration(String id) =>
      _api.delete('${ApiEndpoints.celebrations}/$id');

  @override
  Future<Map<String, dynamic>> scheduleGift(String celebrationId, Map<String, dynamic> payload) =>
      _api.post(ApiEndpoints.scheduleGift, body: {'celebration_id': celebrationId, ...payload});
}

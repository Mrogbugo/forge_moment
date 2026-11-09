import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _api;
  HomeRepositoryImpl({required ApiClient api}) : _api = api;

  @override
  Future<Map<String, dynamic>> getDashboard() =>
      _api.get(ApiEndpoints.meDashboard);

  @override
  Future<List<Map<String, dynamic>>> getRecommendations() async {
    final res = await _api.get(ApiEndpoints.giftIdeas);
    return List<Map<String, dynamic>>.from(res['items'] ?? []);
  }
}

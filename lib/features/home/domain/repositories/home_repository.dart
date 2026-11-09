abstract class HomeRepository {
  Future<Map<String, dynamic>> getDashboard();
  Future<List<Map<String, dynamic>>> getRecommendations();
}

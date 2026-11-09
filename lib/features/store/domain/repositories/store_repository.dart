import '../../../../shared/models/paginated_response.dart';
import '../entities/product.dart';

abstract class StoreRepository {
  Future<List<Map<String, dynamic>>> getCategories();
  Future<PaginatedResponse<Product>> getProducts({
    int page = 1,
    String? categoryId,
    String? query,
    double? minPrice,
    double? maxPrice,
    bool? sameDayOnly,
    bool? featuredOnly,
    String? sortBy,
    String? sortOrder,
  });
  Future<Product> getProduct(String productId);
  Future<PaginatedResponse<Map<String, dynamic>>> getReviews(String productId, {int page = 1});
  Future<void> submitReview(String productId, Map<String, dynamic> payload);
  Future<List<Product>> getSuggestions(String description);
  Future<List<Map<String, dynamic>>> getPackagingOptions();
  Future<Map<String, dynamic>> getDeliveryPricing(Map<String, dynamic> params);
}

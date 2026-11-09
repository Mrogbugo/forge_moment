import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../../../shared/models/paginated_response.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/store_repository.dart';

class StoreRepositoryImpl implements StoreRepository {
  final ApiClient _api;
  StoreRepositoryImpl({required ApiClient api}) : _api = api;

  Product _parse(Map<String, dynamic> j) => Product(
        id: j['id'] as String,
        name: j['name'] as String,
        description: j['description'] as String? ?? '',
        imageUrls: List<String>.from(j['image_urls'] ?? []),
        price: (j['price'] as num).toDouble(),
        categoryId: j['category_id'] as String? ?? '',
        isFeatured: j['is_featured'] as bool? ?? false,
        sameDayAvailable: j['same_day_available'] as bool? ?? false,
        inStock: j['in_stock'] as bool? ?? true,
        variants: (j['variants'] as List? ?? []).map((v) => ProductVariant(
          id: v['id'] as String,
          name: v['name'] as String,
          priceDelta: (v['price_delta'] as num?)?.toDouble(),
          inStock: v['in_stock'] as bool? ?? true,
        )).toList(),
      );

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    final res = await _api.get(ApiEndpoints.storeCategories);
    return List<Map<String, dynamic>>.from(res['categories'] ?? res['items'] ?? []);
  }

  @override
  Future<PaginatedResponse<Product>> getProducts({
    int page = 1, String? categoryId, String? query,
    double? minPrice, double? maxPrice,
    bool? sameDayOnly, bool? featuredOnly,
    String? sortBy, String? sortOrder,
  }) async {
    final res = await _api.get(ApiEndpoints.storeProducts, query: {
      'page': page.toString(),
      if (categoryId != null) 'category_id': categoryId,
      if (query != null) 'q': query,
      if (minPrice != null) 'min_price': minPrice.toString(),
      if (maxPrice != null) 'max_price': maxPrice.toString(),
      if (sameDayOnly == true) 'same_day': 'true',
      if (featuredOnly == true) 'featured': 'true',
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
    return PaginatedResponse.fromJson(res, _parse);
  }

  @override
  Future<Product> getProduct(String productId) async {
    final res = await _api.get(ApiEndpoints.storeProduct.replaceFirst('{id}', productId));
    return _parse(res);
  }

  @override
  Future<PaginatedResponse<Map<String, dynamic>>> getReviews(String productId, {int page = 1}) async {
    final res = await _api.get(
      ApiEndpoints.storeProductReviews.replaceFirst('{id}', productId),
      query: {'page': page.toString()},
    );
    return PaginatedResponse.fromJson(res, (j) => j);
  }

  @override
  Future<void> submitReview(String productId, Map<String, dynamic> payload) =>
      _api.post(ApiEndpoints.storeProductReviews.replaceFirst('{id}', productId), body: payload);

  @override
  Future<List<Product>> getSuggestions(String description) async {
    final res = await _api.post(ApiEndpoints.storeSuggestions, body: {'description': description});
    return List<Map<String, dynamic>>.from(res['products'] ?? []).map(_parse).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getPackagingOptions() async {
    final res = await _api.get(ApiEndpoints.packaging);
    return List<Map<String, dynamic>>.from(res['packaging'] ?? res['items'] ?? []);
  }

  @override
  Future<Map<String, dynamic>> getDeliveryPricing(Map<String, dynamic> params) =>
      _api.post(ApiEndpoints.deliveryPricing, body: params);
}

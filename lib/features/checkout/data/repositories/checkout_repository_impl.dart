import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final ApiClient _api;
  CheckoutRepositoryImpl({required ApiClient api}) : _api = api;

  @override
  Future<List<Map<String, dynamic>>> getDeliveryOptions(Map<String, dynamic> params) async {
    final res = await _api.post(ApiEndpoints.deliveryPricing, body: params);
    return List<Map<String, dynamic>>.from(res['options'] ?? res['items'] ?? []);
  }

  @override
  Future<List<Map<String, dynamic>>> getPackagingOptions() async {
    final res = await _api.get(ApiEndpoints.packaging);
    return List<Map<String, dynamic>>.from(res['packaging'] ?? res['items'] ?? []);
  }

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) =>
      _api.post(ApiEndpoints.orders, body: payload,
          idempotencyKey: payload['idempotency_key'] as String?);

  @override
  Future<Map<String, dynamic>> verifyOrderPayment(String orderId, String reference) =>
      _api.post(ApiEndpoints.orderPaymentVerify.replaceFirst('{id}', orderId),
          body: {'reference': reference});
}

abstract class CheckoutRepository {
  Future<List<Map<String, dynamic>>> getDeliveryOptions(Map<String, dynamic> params);
  Future<List<Map<String, dynamic>>> getPackagingOptions();
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload);
  Future<Map<String, dynamic>> verifyOrderPayment(String orderId, String reference);
}

import '../../../../shared/models/paginated_response.dart';
import '../entities/order.dart';

abstract class OrdersRepository {
  Future<PaginatedResponse<Order>> getOrders({int page = 1});
  Future<Order> getOrder(String orderId);
  Future<List<TrackingEvent>> getTracking(String orderId);
  Future<Order> cancelOrder(String orderId, String reason);
  Future<Order> verifyPayment(String orderId, String reference);
}

import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../../../shared/models/paginated_response.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final ApiClient _api;
  OrdersRepositoryImpl({required ApiClient api}) : _api = api;

  Order _parse(Map<String, dynamic> j) => Order(
        id: j['id'] as String,
        reference: j['reference'] as String,
        items: (j['items'] as List? ?? []).map((i) => OrderItem(
          productId: i['product_id'] as String,
          productName: i['product_name'] as String,
          quantity: i['quantity'] as int,
          unitPrice: (i['unit_price'] as num).toDouble(),
          fulfilmentStatus: i['fulfilment_status'] as String?,
        )).toList(),
        subtotal: (j['subtotal'] as num).toDouble(),
        deliveryCharge: (j['delivery_charge'] as num? ?? 0).toDouble(),
        packagingCharge: (j['packaging_charge'] as num? ?? 0).toDouble(),
        total: (j['total'] as num).toDouble(),
        status: OrderStatus.values.firstWhere(
            (s) => s.name == (j['status'] as String? ?? 'pendingPayment'),
            orElse: () => OrderStatus.pendingPayment),
        recipientName: j['recipient_name'] as String?,
        addressSummary: j['address_summary'] as String?,
        createdAt: DateTime.parse(j['created_at'] as String),
      );

  @override
  Future<PaginatedResponse<Order>> getOrders({int page = 1}) async {
    final res = await _api.get(ApiEndpoints.orders, query: {'page': page.toString()});
    return PaginatedResponse.fromJson(res, _parse);
  }

  @override
  Future<Order> getOrder(String orderId) async {
    final res = await _api.get(ApiEndpoints.orderDetail.replaceFirst('{id}', orderId));
    return _parse(res);
  }

  @override
  Future<List<TrackingEvent>> getTracking(String orderId) async {
    final res = await _api.get(ApiEndpoints.orderTracking.replaceFirst('{id}', orderId));
    return (res['events'] as List? ?? []).map((e) => TrackingEvent(
      description: e['description'] as String,
      timestamp: DateTime.parse(e['timestamp'] as String),
    )).toList();
  }

  @override
  Future<Order> cancelOrder(String orderId, String reason) async {
    final res = await _api.post(ApiEndpoints.orderCancel.replaceFirst('{id}', orderId),
        body: {'reason': reason});
    return _parse(res);
  }

  @override
  Future<Order> verifyPayment(String orderId, String reference) async {
    final res = await _api.post(ApiEndpoints.orderPaymentVerify.replaceFirst('{id}', orderId),
        body: {'reference': reference});
    return _parse(res);
  }
}

enum OrderStatus { pendingPayment, paid, processing, dispatched, delivered, cancelled, failed }

class Order {
  final String id;
  final String reference;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryCharge;
  final double packagingCharge;
  final double total;
  final OrderStatus status;
  final String? recipientName;
  final String? addressSummary;
  final DateTime createdAt;
  final List<TrackingEvent> trackingEvents;

  const Order({
    required this.id,
    required this.reference,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.packagingCharge,
    required this.total,
    required this.status,
    this.recipientName,
    this.addressSummary,
    required this.createdAt,
    this.trackingEvents = const [],
  });
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final String? fulfilmentStatus;
  const OrderItem({required this.productId, required this.productName, required this.quantity, required this.unitPrice, this.fulfilmentStatus});
}

class TrackingEvent {
  final String description;
  final DateTime timestamp;
  const TrackingEvent({required this.description, required this.timestamp});
}

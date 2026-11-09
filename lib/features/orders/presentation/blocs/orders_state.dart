part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final List<Order> orders;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final Order? selectedOrder;
  final List<TrackingEvent> trackingEvents;
  final bool isLoadingDetail;
  final bool isCancelling;
  final String? errorMessage;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.selectedOrder,
    this.trackingEvents = const [],
    this.isLoadingDetail = false,
    this.isCancelling = false,
    this.errorMessage,
  });

  factory OrdersState.initial() => const OrdersState();

  OrdersState copyWith({
    List<Order>? orders,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    Order? selectedOrder,
    List<TrackingEvent>? trackingEvents,
    bool? isLoadingDetail,
    bool? isCancelling,
    String? errorMessage,
    bool clearSelectedOrder = false,
    bool clearError = false,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      selectedOrder: clearSelectedOrder ? null : (selectedOrder ?? this.selectedOrder),
      trackingEvents: trackingEvents ?? this.trackingEvents,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isCancelling: isCancelling ?? this.isCancelling,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        orders,
        isLoading,
        hasMore,
        currentPage,
        selectedOrder,
        trackingEvents,
        isLoadingDetail,
        isCancelling,
        errorMessage,
      ];
}

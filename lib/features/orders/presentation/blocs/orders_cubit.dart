import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _repository;

  OrdersCubit({required OrdersRepository repository})
      : _repository = repository,
        super(OrdersState.initial());

  Future<void> loadOrders({bool refresh = false}) async {
    // TODO: implement
  }

  Future<void> loadMore() async {
    // TODO: implement
  }

  Future<void> loadOrderDetail(String orderId) async {
    // TODO: implement
  }

  Future<void> loadTracking(String orderId) async {
    // TODO: implement
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    // TODO: implement
  }

  Future<void> verifyPayment(String orderId, String reference) async {
    // TODO: implement
  }
}

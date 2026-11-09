import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit({required CartRepository repository})
      : _repository = repository,
        super(CartState.initial());

  Future<void> loadCart() async {
    // TODO: implement
  }

  Future<void> addItem(
    String productId, {
    String? variantId,
    int quantity = 1,
  }) async {
    // TODO: implement
  }

  Future<void> updateItem(
    String productId, {
    String? variantId,
    required int quantity,
  }) async {
    // TODO: implement
  }

  Future<void> removeItem(String productId, {String? variantId}) async {
    // TODO: implement
  }

  Future<void> clearCart() async {
    // TODO: implement
  }

  Future<void> calculateCart(Map<String, dynamic> params) async {
    // TODO: implement
  }
}

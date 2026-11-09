import '../entities/cart.dart';

abstract class CartRepository {
  Future<Cart> getCart();
  Future<Cart> addItem(String productId, String? variantId, int quantity);
  Future<Cart> updateItem(String productId, String? variantId, int quantity);
  Future<Cart> removeItem(String productId, String? variantId);
  Future<void> clearCart();
  Future<Map<String, dynamic>> calculateCart(Map<String, dynamic> params);
}

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/api/api_client.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';

/// Cart is persisted locally in Hive and reconciled with the server
/// via the cart-calculation endpoint (FR-CART-003).
class CartRepositoryImpl implements CartRepository {
  final ApiClient _api;
  static const _boxName = 'cart';
  late final Box<String> _box;

  CartRepositoryImpl({required ApiClient api}) : _api = api;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  @override
  Future<Cart> getCart() async {
    final raw = _box.get('current');
    if (raw == null) return const Cart(items: [], subtotal: 0);
    return _parseCart(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<Cart> addItem(String productId, String? variantId, int quantity) async {
    final cart = await getCart();
    final updated = _upsert(cart, productId, variantId, quantity);
    await _persist(updated);
    return updated;
  }

  @override
  Future<Cart> updateItem(String productId, String? variantId, int quantity) async {
    final cart = await getCart();
    final updated = _upsert(cart, productId, variantId, quantity);
    await _persist(updated);
    return updated;
  }

  @override
  Future<Cart> removeItem(String productId, String? variantId) async {
    final cart = await getCart();
    final items = cart.items.where((i) => !(i.productId == productId && i.variantId == variantId)).toList();
    final updated = Cart(items: items, subtotal: _calcSubtotal(items));
    await _persist(updated);
    return updated;
  }

  @override
  Future<void> clearCart() => _box.delete('current');

  @override
  Future<Map<String, dynamic>> calculateCart(Map<String, dynamic> params) =>
      _api.post('/api/v1/store/cart/calculate', body: params);

  Cart _upsert(Cart cart, String productId, String? variantId, int quantity) {
    final items = [...cart.items];
    final idx = items.indexWhere((i) => i.productId == productId && i.variantId == variantId);
    if (idx >= 0) {
      items[idx] = CartItem(
        productId: productId,
        productName: items[idx].productName,
        variantId: variantId,
        variantName: items[idx].variantName,
        quantity: quantity,
        unitPrice: items[idx].unitPrice,
      );
    }
    return Cart(items: items, subtotal: _calcSubtotal(items));
  }

  double _calcSubtotal(List<CartItem> items) =>
      items.fold(0, (s, i) => s + i.lineTotal);

  Future<void> _persist(Cart cart) =>
      _box.put('current', jsonEncode(_cartToJson(cart)));

  Map<String, dynamic> _cartToJson(Cart c) => {
    'items': c.items.map((i) => {
      'product_id': i.productId, 'product_name': i.productName,
      'image_url': i.imageUrl, 'variant_id': i.variantId,
      'variant_name': i.variantName, 'quantity': i.quantity,
      'unit_price': i.unitPrice,
    }).toList(),
    'subtotal': c.subtotal,
  };

  Cart _parseCart(Map<String, dynamic> j) => Cart(
    subtotal: (j['subtotal'] as num).toDouble(),
    items: (j['items'] as List).map((i) => CartItem(
      productId: i['product_id'] as String,
      productName: i['product_name'] as String,
      imageUrl: i['image_url'] as String?,
      variantId: i['variant_id'] as String?,
      variantName: i['variant_name'] as String?,
      quantity: i['quantity'] as int,
      unitPrice: (i['unit_price'] as num).toDouble(),
    )).toList(),
  );
}

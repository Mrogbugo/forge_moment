class Cart {
  final List<CartItem> items;
  final double subtotal;

  const Cart({required this.items, required this.subtotal});

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);
}

class CartItem {
  final String productId;
  final String productName;
  final String? imageUrl;
  final String? variantId;
  final String? variantName;
  final int quantity;
  final double unitPrice;

  const CartItem({
    required this.productId,
    required this.productName,
    this.imageUrl,
    this.variantId,
    this.variantName,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => unitPrice * quantity;
}

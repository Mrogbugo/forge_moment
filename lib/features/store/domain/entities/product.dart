class Product {
  final String id;
  final String name;
  final String description;
  final List<String> imageUrls;
  final double price;
  final String categoryId;
  final bool isFeatured;
  final bool sameDayAvailable;
  final bool inStock;
  final List<ProductVariant> variants;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.price,
    required this.categoryId,
    this.isFeatured = false,
    this.sameDayAvailable = false,
    this.inStock = true,
    this.variants = const [],
  });
}

class ProductVariant {
  final String id;
  final String name;
  final double? priceDelta;
  final bool inStock;

  const ProductVariant({
    required this.id,
    required this.name,
    this.priceDelta,
    this.inStock = true,
  });
}

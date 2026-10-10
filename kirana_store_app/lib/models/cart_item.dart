import 'product.dart';

class CartItem {
  final Product product;
  ProductVariant variant;
  int quantity;

  CartItem({
    required this.product,
    required this.variant,
    this.quantity = 1,
  });

  String get cartKey => '${product.id}_${variant.id}';

  double get itemTotal => variant.price * quantity;

  double get mrpTotal => variant.mrp * quantity;

  double get savings => (variant.mrp > variant.price)
      ? (variant.mrp - variant.price) * quantity
      : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'product': product.toJson(),
      'variant': variant.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      variant: ProductVariant.fromJson(json['variant'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}

import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  List<CartItem> get cartList => _items.values.toList();

  bool get isEmpty => _items.isEmpty;

  int get totalItemCount {
    int total = 0;
    _items.forEach((_, item) {
      total += item.quantity;
    });
    return total;
  }

  double get subtotal {
    double total = 0.0;
    _items.forEach((_, item) {
      total += item.itemTotal;
    });
    return total;
  }

  double get totalMrp {
    double total = 0.0;
    _items.forEach((_, item) {
      total += item.mrpTotal;
    });
    return total;
  }

  double get totalSavings {
    final diff = totalMrp - subtotal;
    return diff > 0 ? diff : 0.0;
  }

  double get grandTotal => subtotal;

  int getQuantity(Product product, ProductVariant variant) {
    final key = '${product.id}_${variant.id}';
    return _items[key]?.quantity ?? 0;
  }

  void addItem(Product product, ProductVariant variant) {
    final key = '${product.id}_${variant.id}';
    if (_items.containsKey(key)) {
      _items[key]!.quantity += 1;
    } else {
      _items[key] = CartItem(
        product: product,
        variant: variant,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void removeItem(Product product, ProductVariant variant) {
    final key = '${product.id}_${variant.id}';
    if (!_items.containsKey(key)) return;

    if (_items[key]!.quantity > 1) {
      _items[key]!.quantity -= 1;
    } else {
      _items.remove(key);
    }
    notifyListeners();
  }

  void updateQuantity(Product product, ProductVariant variant, int qty) {
    final key = '${product.id}_${variant.id}';
    if (qty <= 0) {
      _items.remove(key);
    } else {
      if (_items.containsKey(key)) {
        _items[key]!.quantity = qty;
      } else {
        _items[key] = CartItem(
          product: product,
          variant: variant,
          quantity: qty,
        );
      }
    }
    notifyListeners();
  }

  void deleteItem(String cartKey) {
    _items.remove(cartKey);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

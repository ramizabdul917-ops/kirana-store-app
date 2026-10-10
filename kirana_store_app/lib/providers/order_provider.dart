import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/storage_service.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  OrderModel? _activeOrder;
  bool _isLoading = false;

  OrderProvider() {
    loadOrders();
  }

  List<OrderModel> get orders => [..._orders];
  OrderModel? get activeOrder => _activeOrder;
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    _orders = await StorageService.loadOrders();
    _isLoading = false;
    notifyListeners();
  }

  // 1. Place Regular Cart Order
  Future<OrderModel> placeCartOrder({
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double grandTotal,
    required String paymentMethod,
  }) async {
    final tokenNum = await StorageService.getNextTokenNumber();
    final tokenCode = '#K-$tokenNum';
    final orderId = 'ORD_${DateTime.now().millisecondsSinceEpoch}';

    final newOrder = OrderModel(
      id: orderId,
      tokenCode: tokenCode,
      customerName: customerName.trim(),
      customerPhone: customerPhone.trim(),
      customerAddress: customerAddress.trim(),
      items: items,
      subtotal: subtotal,
      discount: discount,
      grandTotal: grandTotal,
      paymentMethod: paymentMethod,
      orderType: "CART",
      status: "PENDING",
      createdAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    _activeOrder = newOrder;
    notifyListeners();

    await StorageService.saveOrders(_orders);
    return newOrder;
  }

  // 2. Place Parchi (Handwritten list) Order
  Future<OrderModel> placeParchiOrder({
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    String? parchiText,
    String? parchiImagePath,
    required String paymentMethod,
  }) async {
    final tokenNum = await StorageService.getNextTokenNumber();
    final tokenCode = '#K-$tokenNum';
    final orderId = 'PARCHI_${DateTime.now().millisecondsSinceEpoch}';

    final newOrder = OrderModel(
      id: orderId,
      tokenCode: tokenCode,
      customerName: customerName.trim(),
      customerPhone: customerPhone.trim(),
      customerAddress: customerAddress.trim(),
      items: [],
      parchiText: parchiText,
      parchiImagePath: parchiImagePath,
      subtotal: 0.0,
      discount: 0.0,
      grandTotal: 0.0,
      paymentMethod: paymentMethod,
      orderType: "PARCHI",
      status: "PENDING",
      createdAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    _activeOrder = newOrder;
    notifyListeners();

    await StorageService.saveOrders(_orders);
    return newOrder;
  }

  // Quick Token Lookup for Shopkeeper / Admin (1-minute packing)
  OrderModel? findOrderByToken(String query) {
    if (query.trim().isEmpty) return null;
    final cleanQuery = query.replaceAll(RegExp(r'[^0-9]'), '');

    for (final order in _orders) {
      final cleanToken = order.tokenCode.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanToken == cleanQuery || order.tokenCode.toLowerCase().contains(query.toLowerCase())) {
        return order;
      }
    }
    return null;
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      if (_activeOrder?.id == orderId) {
        _activeOrder?.status = newStatus;
      }
      notifyListeners();
      await StorageService.saveOrders(_orders);
    }
  }

  void setActiveOrder(OrderModel order) {
    _activeOrder = order;
    notifyListeners();
  }
}
